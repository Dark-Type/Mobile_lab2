//
//  LibraryFeature.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct LibraryFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        var featuredBooks: [BookUI] = []
        var popularBooks: [BookUI] = []
        var selectedBookForReading: BookUI? = nil
        var isReadingScreenPresented: Bool = false
        var isLoading: Bool = false
        var hasLoadedInitialData: Bool = false
        var carouselCurrentIndex: Int = 0
        var errorMessage: String? = nil

        var hasFeaturedBooks: Bool {
            !featuredBooks.isEmpty
        }

        var hasPopularBooks: Bool {
            !popularBooks.isEmpty
        }
    }

    // MARK: - Action

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)

        case viewAppeared
        case loadBooks
        case featuredBooksLoaded([BookUI])
        case popularBooksLoaded([BookUI])
        case booksLoadingFailed(String)

        case bookSelectedForReading(BookUI?)
        case readingScreenDismissed
        case setCurrentBook(BookUI)
        case toggleFavorite(BookUI)

        case carouselIndexChanged(Int)

        case delegate(Delegate)

        enum Delegate: Equatable {
            case setCurrentBook(BookUI)
            case toggleFavorite(BookUI)
        }
    }

    // MARK: - Dependencies

    @Dependency(\.bookRepository) var bookRepository

    // MARK: - Cancellation IDs

    private enum CancelID {
        case loadBooks
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
                    return .send(.loadBooks)
                }
                return .none

            case .loadBooks:
                guard !state.isLoading else {
                    return .none
                }

                state.isLoading = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        async let featuredTask = bookService.getNewBooks(isNew: true)
                        async let popularTask = bookService.getBooks(page: 1, pageSize: 9)

                        let featuredBooks = try await featuredTask
                        await send(.featuredBooksLoaded(featuredBooks))

                        let popularBooks = try await popularTask
                        await send(.popularBooksLoaded(popularBooks))

                    } catch {
                        await send(.booksLoadingFailed(error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.loadBooks, cancelInFlight: true)

            case let .featuredBooksLoaded(books):
                state.featuredBooks = books
                return .none

            case let .popularBooksLoaded(books):
                state.popularBooks = books
                state.isLoading = false
                state.hasLoadedInitialData = true
                return .none

            case let .booksLoadingFailed(errorMessage):
                state.isLoading = false
                state.hasLoadedInitialData = true
                state.errorMessage = errorMessage
                return .none

            case let .bookSelectedForReading(book):
                state.selectedBookForReading = book
                if book != nil {
                    state.isReadingScreenPresented = true
                }
                return .none

            case .readingScreenDismissed:
                state.isReadingScreenPresented = false
                state.selectedBookForReading = nil
                return .none

            case let .setCurrentBook(book):
                return .send(.delegate(.setCurrentBook(book)))

            case let .toggleFavorite(book):
                return .send(.delegate(.toggleFavorite(book)))

            case let .carouselIndexChanged(index):
                state.carouselCurrentIndex = index
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
