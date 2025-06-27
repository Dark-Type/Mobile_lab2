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
        var selectedBookForReading: Book? = nil
        var showNoBookAlert: Bool = false

        var currentBook: Book? = nil
        var favoriteBooks: [Book] = []
        var favoriteBookIDs: [String] = []

        var hasFavoriteBooks: Bool {
            !favoriteBooks.isEmpty
        }

        var hasCurrentBook: Bool {
            currentBook != nil
        }

        func isFavorite(_ book: Book) -> Bool {
            favoriteBookIDs.contains(book.id.uuidString)
        }
    }

    // MARK: - Action

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)

        case tabSelected(Int)

        case setCurrentBook(Book)
        case bookSelectedForReading(Book?)
        case toggleFavorite(Book)

        case readingButtonTapped
        case readingScreenDismissed

        case noBookAlertPresented
        case noBookAlertDismissed

        case logoutButtonTapped

        case viewAppeared
        case currentBookLoaded(Book?)
        case favoriteBooksLoaded([Book])
        case favoriteBookIDsLoaded([String])
        case favoriteToggled(Book, Bool)
    }

    // MARK: - Dependencies

    @Dependency(\.bookService) var bookService
    @Dependency(\.favoritesService) var favoritesService
    @Dependency(\.userDefaultsService) var userDefaultsService

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case let .tabSelected(index):
                state.selectedTab = index
                return .none

            case let .setCurrentBook(book):
                state.currentBook = book
                return .run { _ in
                    await userDefaultsService.setCurrentBookID(book.id.uuidString)
                }

            case let .bookSelectedForReading(book):
                state.selectedBookForReading = book
                if book != nil {
                    state.isReadingScreenPresented = true
                }
                return .none

            case let .toggleFavorite(book):
                let isFavorite = state.isFavorite(book)

                return .run { send in
                    if isFavorite {
                        await favoritesService.removeFromFavorites(book)
                    } else {
                        await favoritesService.addToFavorites(book)
                    }
                    await send(.favoriteToggled(book, !isFavorite))
                }

            case .readingButtonTapped:
                if state.hasCurrentBook {
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
                return .run { _ in
                    await userDefaultsService.setLoggedIn(false)
                }

            case .viewAppeared:
                return .run { send in
                    async let currentBook = bookService.getCurrentBook()
                    async let favoriteBooks = favoritesService.getFavoriteBooks()
                    async let favoriteBookIDs = userDefaultsService.getFavoriteBookIDs()

                    await send(.currentBookLoaded(currentBook))
                    await send(.favoriteBooksLoaded(favoriteBooks))
                    await send(.favoriteBookIDsLoaded(favoriteBookIDs))
                }

            case let .currentBookLoaded(book):
                state.currentBook = book
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
            }
        }
    }
}
