//
//  BookmarksFeature.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct BookmarksFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        var currentlyReadingBooks: [Book] = []
        var favoriteBooks: [Book] = []
        var quotes: [Quote] = []

        var selectedBookForReading: Book? = nil
        var selectedChapterForReading: BookChapterSelection? = nil
        var isReadingScreenPresented: Bool = false
        var isChapterReadingPresented: Bool = false

        var isLoading: Bool = false
        var hasLoadedInitialData: Bool = false
        var errorMessage: String? = nil

        var hasCurrentlyReadingBooks: Bool {
            !currentlyReadingBooks.isEmpty
        }

        var hasFavoriteBooks: Bool {
            !favoriteBooks.isEmpty
        }

        var hasQuotes: Bool {
            !quotes.isEmpty
        }

        var topCurrentBook: Book? {
            currentlyReadingBooks.first
        }
    }

    // MARK: - Action

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)

        case viewAppeared
        case loadInitialData
        case initialDataLoaded(currentBooks: [Book], favoriteBooks: [Book], quotes: [Quote])
        case initialDataLoadingFailed(String)

        case continueReading(Book)
        case continueReadingWithChapter(Book, Chapter)
        case removeFromCurrentlyReading(Book)
        case currentBookRemoved(Book)

        case bookSelectedForReading(Book?)
        case chapterSelectedForReading(Book, Chapter)
        case readingScreenDismissed
        case chapterReadingScreenDismissed

        case removeFromFavorites(Book)
        case favoriteBookRemoved(Book)

        case removeQuote(Quote)
        case quoteRemoved(Quote)

        case clearError

        case delegate(Delegate)

        enum Delegate: Equatable {
            case setCurrentBook(Book)
            case setCurrentBookAndChapter(Book, Chapter)
            case toggleFavorite(Book)
        }
    }

    // MARK: - Dependencies

    @Dependency(\.bookRepository) var bookRepository
    @Dependency(\.favoriteRepository) var favoriteRepository

    // MARK: - Cancellation IDs

    private enum CancelID {
        case loadInitialData
        case removeCurrentBook
        case removeFavoriteBook
        case removeQuote
    }

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .viewAppeared:
                if !state.hasLoadedInitialData && !state.isLoading {
                    return .send(.loadInitialData)
                }
                return .none

            case .loadInitialData:
                state.isLoading = true
                state.errorMessage = nil

                return .run { send in

                    async let currentBooks = bookService.getCurrentBooks()
                    async let favoriteBooks = favoritesService.getFavoriteBooks()
                    async let quotes = favoritesService.getQuotes()

                    let (loadedCurrentBooks, loadedFavoriteBooks, loadedQuotes) = await (currentBooks, favoriteBooks, quotes)

                    await send(.initialDataLoaded(
                        currentBooks: loadedCurrentBooks,
                        favoriteBooks: loadedFavoriteBooks,
                        quotes: loadedQuotes
                    ))
                }
                .cancellable(id: CancelID.loadInitialData, cancelInFlight: true)

            case let .initialDataLoaded(currentBooks, favoriteBooks, quotes):
                state.currentlyReadingBooks = currentBooks
                state.favoriteBooks = favoriteBooks
                state.quotes = quotes
                state.isLoading = false
                state.hasLoadedInitialData = true
                return .none

            case let .initialDataLoadingFailed(error):
                state.isLoading = false
                state.hasLoadedInitialData = true
                state.errorMessage = error
                return .none

            case let .continueReading(book):

                return .run { send in
                    await bookService.moveBookToTop(book)
                    await send(.delegate(.setCurrentBook(book)))
                }

            case let .continueReadingWithChapter(book, chapter):
                state.selectedChapterForReading = BookChapterSelection(book: book, chapter: chapter)
                state.isChapterReadingPresented = true

                return .run { send in
                    await bookService.moveBookToTop(book)
                    await send(.delegate(.setCurrentBookAndChapter(book, chapter)))
                }

            case let .removeFromCurrentlyReading(book):
                return .run { send in
                    await bookService.removeFromCurrentBooks(book)
                    await send(.currentBookRemoved(book))
                }
                .cancellable(id: CancelID.removeCurrentBook, cancelInFlight: true)

            case let .currentBookRemoved(book):
                state.currentlyReadingBooks.removeAll { $0.id == book.id }
                return .none

            case let .bookSelectedForReading(book):
                state.selectedBookForReading = book
                if book != nil {
                    state.isReadingScreenPresented = true
                }
                return .none

            case let .chapterSelectedForReading(book, chapter):
                return .send(.continueReadingWithChapter(book, chapter))

            case .readingScreenDismissed:
                state.isReadingScreenPresented = false
                state.selectedBookForReading = nil
                return .none

            case .chapterReadingScreenDismissed:
                state.isChapterReadingPresented = false
                state.selectedChapterForReading = nil
                return .none

            case let .removeFromFavorites(book):
                return .run { send in
                    await favoritesService.removeFromFavorites(book)
                    await send(.favoriteBookRemoved(book))
                    await send(.delegate(.toggleFavorite(book)))
                }
                .cancellable(id: CancelID.removeFavoriteBook, cancelInFlight: true)

            case let .favoriteBookRemoved(book):
                state.favoriteBooks.removeAll { $0.id == book.id }
                return .none

            case let .removeQuote(quote):
                return .run { send in
                    await favoritesService.removeQuote(quote)
                    await send(.quoteRemoved(quote))
                }
                .cancellable(id: CancelID.removeQuote, cancelInFlight: true)

            case let .quoteRemoved(quote):
                state.quotes.removeAll { $0.id == quote.id }
                return .none

            case .clearError:
                state.errorMessage = nil
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
