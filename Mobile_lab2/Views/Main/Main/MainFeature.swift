//
//  MainFeature.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct MainFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        var selectedTab: Int = 0
        var isReadingScreenPresented: Bool = false
        var selectedBookForReading: BookUI? = nil
        var showNoBookAlert: Bool = false

        var currentBooks: [BookUI] = []
        var favoriteBooks: [BookUI] = []
        var favoriteBookIDs: [String] = []

        var library = LibraryFeature.State()
        var search = SearchFeature.State()
        var bookmarks = BookmarksFeature.State()

        var hasFavoriteBooks: Bool {
            !favoriteBooks.isEmpty
        }

        var hasCurrentBooks: Bool {
            !currentBooks.isEmpty
        }

        var topCurrentBook: BookUI? {
            currentBooks.first
        }

        func isFavorite(_ book: BookUI) -> Bool {
            favoriteBookIDs.contains(book.id)
        }
    }

    // MARK: - Action

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)

        case tabSelected(Int)

        case setCurrentBook(BookUI)
        case setCurrentBookAndChapter(BookUI, Chapter)
        case addToCurrentBooks(BookUI)
        case bookSelectedForReading(BookUI?)
        case toggleFavorite(BookUI)

        case readingButtonTapped
        case readingScreenDismissed

        case noBookAlertPresented
        case noBookAlertDismissed

        case logoutButtonTapped

        case viewAppeared
        case currentBooksLoaded([BookUI])
        case favoriteBooksLoaded([BookUI])
        case favoriteBookIDsLoaded([String])
        case favoriteToggled(BookUI, Bool)

        case library(LibraryFeature.Action)
        case search(SearchFeature.Action)
        case bookmarks(BookmarksFeature.Action)

        case delegate(Delegate)

        enum Delegate: Equatable {
            case logout
        }
    }

    // MARK: - Dependencies

    @Dependency(\.bookRepository) var bookRepository
    @Dependency(\.favoriteRepository) var favoriteRepository
    @Dependency(\.userDefaultsService) var userDefaultsService

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        BindingReducer()

        Scope(state: \.library, action: \.library) {
            LibraryFeature()
        }

        Scope(state: \.search, action: \.search) {
            SearchFeature()
        }

        Scope(state: \.bookmarks, action: \.bookmarks) {
            BookmarksFeature()
        }

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case let .tabSelected(index):
                state.selectedTab = index

                switch index {
                case 0:
                    if state.library.featuredBooks.isEmpty && state.library.popularBooks.isEmpty && !state.library.isLoading {
                        return .send(.library(.viewAppeared))
                    }
                case 1:
                    if !state.search.hasLoadedInitialData && !state.search.isLoadingInitialData {
                        return .send(.search(.viewAppeared))
                    }
                case 2:
                    if !state.bookmarks.hasLoadedInitialData && !state.bookmarks.isLoading {
                        return .send(.bookmarks(.viewAppeared))
                    }
                default:
                    break
                }
                return .none

            case let .setCurrentBook(book):
                state.currentBooks.removeAll { $0.id == book.id }
                state.currentBooks.insert(book, at: 0)

                return .run { _ in
                    await userDefaultsService.setCurrentBookID(book.id.uuidString)
                }

            case let .setCurrentBookAndChapter(book, chapter):
                state.currentBooks.removeAll { $0.id == book.id }
                state.currentBooks.insert(book, at: 0)

                return .run { _ in

                    await userDefaultsService.setCurrentBookID(book.id.uuidString)
                }

            case let .addToCurrentBooks(book):
                if !state.currentBooks.contains(where: { $0.id == book.id }) {
                    state.currentBooks.insert(book, at: 0)

                    return .run { _ in
                    }
                }
                return .none

            case let .bookSelectedForReading(book):
                state.selectedBookForReading = book
                if book != nil {
                    state.isReadingScreenPresented = true
                } else {
                    state.isReadingScreenPresented = false
                }
                return .none

            case let .toggleFavorite(book):
                let isFavorite = state.isFavorite(book)

                return .run { send in
                    if isFavorite {
                        await favoriteRepository.removeFromFavorites(book.id)
                    } else {
                        await favoriteRepository.addToFavorites(book)
                    }
                    await send(.favoriteToggled(book, !isFavorite))
                }

            case .readingButtonTapped:
                if state.hasCurrentBooks, let topBook = state.topCurrentBook {
                    state.selectedBookForReading = topBook
                    state.isReadingScreenPresented = true
                } else {
                    state.showNoBookAlert = true
                }
                return .none

            case .readingScreenDismissed:
                state.isReadingScreenPresented = false
                state.selectedBookForReading = nil
                return .none

            case .noBookAlertPresented:
                state.showNoBookAlert = true
                return .none

            case .noBookAlertDismissed:
                state.showNoBookAlert = false
                return .none

            case .logoutButtonTapped:
                return .send(.delegate(.logout))

            case .viewAppeared:
                return .run { send in
                    async let currentBooks = bookService.getCurrentBooks()
                    async let favoriteBooks = favoriteRepository.getFavoriteBooks()
                    async let favoriteBookIDs = userDefaultsService.getFavoriteBookIDs()

                    await send(.library(.viewAppeared))

                    await send(.currentBooksLoaded(currentBooks))
                    await send(.favoriteBooksLoaded(favoriteBooks))
                    await send(.favoriteBookIDsLoaded(favoriteBookIDs))
                }

            case let .currentBooksLoaded(books):
                state.currentBooks = books
                return .none

            case let .favoriteBooksLoaded(books):
                state.favoriteBooks = books
                return .none

            case let .favoriteBookIDsLoaded(bookIDs):
                state.favoriteBookIDs = bookIDs
                return .none

            case let .favoriteToggled(book, isFavorite):
                let bookID = book.id.uuidString

                if isFavorite {
                    if !state.favoriteBookIDs.contains(bookID) {
                        state.favoriteBookIDs.append(bookID)
                    }
                    if !state.favoriteBooks.contains(where: { $0.id == book.id }) {
                        state.favoriteBooks.append(book)
                    }
                } else {
                    state.favoriteBookIDs.removeAll { $0 == bookID }
                    state.favoriteBooks.removeAll { $0.id == book.id }
                }

                let favoriteBookIDs = state.favoriteBookIDs
                return .run { _ in
                    await userDefaultsService.setFavoriteBookIDs(favoriteBookIDs)
                }

            case let .library(.delegate(.setCurrentBook(book))):
                return .send(.setCurrentBook(book))

            case let .library(.delegate(.toggleFavorite(book))):
                return .send(.toggleFavorite(book))

            case .library:
                return .none

            case let .search(.delegate(.setCurrentBook(book))):
                return .send(.setCurrentBook(book))

            case let .search(.delegate(.toggleFavorite(book))):
                return .send(.toggleFavorite(book))

            case .search:
                return .none

            case let .bookmarks(.delegate(.setCurrentBook(book))):
                return .send(.setCurrentBook(book))

            case let .bookmarks(.delegate(.setCurrentBookAndChapter(book, chapter))):
                return .send(.setCurrentBookAndChapter(book, chapter))

            case let .bookmarks(.delegate(.toggleFavorite(book))):
                return .send(.toggleFavorite(book))

            case .bookmarks:
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
