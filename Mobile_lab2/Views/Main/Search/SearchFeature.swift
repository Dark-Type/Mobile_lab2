//
//  SearchFeature.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SearchFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        var searchText: String = ""
        var searchResults: [BookUI] = []
        var recentSearches: [String] = []
        var genres: [String] = []
        var authors: [Author] = []

        var selectedBookForReading: BookUI? = nil
        var isReadingScreenPresented: Bool = false

        var isSearching: Bool = false
        var isLoadingInitialData: Bool = false
        var hasLoadedInitialData: Bool = false

        var errorMessage: String? = nil

        var isSearchTextEmpty: Bool {
            searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        var hasSearchResults: Bool {
            !searchResults.isEmpty
        }

        var hasRecentSearches: Bool {
            !recentSearches.isEmpty
        }

        var hasGenres: Bool {
            !genres.isEmpty
        }

        var hasAuthors: Bool {
            !authors.isEmpty
        }
    }

    // MARK: - Action

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)

        case viewAppeared
        case loadInitialData
        case initialDataLoaded(recentSearches: [String], genres: [String], authors: [Author])
        case initialDataLoadingFailed(String)

        case searchTextChanged(String)
        case searchTextDebounced(String)
        case searchBooks(String)
        case searchResultsLoaded([BookUI])
        case searchFailed(String)
        case clearSearchText

        case recentSearchTapped(String)
        case removeRecentSearch(Int)
        case recentSearchRemoved(Int)

        case genreTapped(String)
        case authorTapped(Author)

        case bookSelectedForReading(BookUI?)
        case readingScreenDismissed
        case setCurrentBook(BookUI)
        case toggleFavorite(BookUI)

        case clearError

        case delegate(Delegate)

        enum Delegate: Equatable {
            case setCurrentBook(BookUI)
            case toggleFavorite(BookUI)
        }
    }

    // MARK: - Dependencies

    @Dependency(\.bookRepository) var bookRepository
    @Dependency(\.continuousClock) var clock
    @Dependency(\.userDefaultsService) var userDefaultsService
    @Dependency(\.referenceDataRepository) var referenceDataRepository

    // MARK: - Cancellation IDs

    private enum CancelID {
        case searchDebounce
        case searchBooks
        case loadInitialData
    }

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.searchText):
                return .send(.searchTextChanged(state.searchText))

            case .binding:
                return .none

            case .viewAppeared:

                if !state.hasLoadedInitialData && !state.isLoadingInitialData {
                    return .send(.loadInitialData)
                }
                return .none

            case .loadInitialData:
                state.isLoadingInitialData = true
                state.errorMessage = nil

                return .run { send in
                        async let recentSearches = userDefaultsService.getSearchRequests()
                        async let genres = referenceDataRepository.getGenres()
                        async let authors = referenceDataRepository.getAuthors()

                        let (loadedSearches, loadedGenres, loadedAuthors) =  await (recentSearches, genres, authors)

                        await send(.initialDataLoaded(
                            recentSearches: loadedSearches,
                            genres: loadedGenres,
                            authors: loadedAuthors
                        ))
                }
                .cancellable(id: CancelID.loadInitialData, cancelInFlight: true)

            case let .initialDataLoaded(recentSearches, genres, authors):
                state.recentSearches = recentSearches
                state.genres = genres
                state.authors = authors
                state.isLoadingInitialData = false
                state.hasLoadedInitialData = true
                return .none

            case let .initialDataLoadingFailed(error):
                state.isLoadingInitialData = false
                state.hasLoadedInitialData = true
                state.errorMessage = error
                return .none

            case let .searchTextChanged(text):
                state.searchText = text

                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    state.searchResults = []
                    state.isSearching = false
                    return .cancel(id: CancelID.searchDebounce)
                }

                return .run { send in
                    try await clock.sleep(for: .milliseconds(300))
                    await send(.searchTextDebounced(text))
                }
                .cancellable(id: CancelID.searchDebounce, cancelInFlight: true)

            case let .searchTextDebounced(text):
                guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    return .none
                }
                return .send(.searchBooks(text))

            case let .searchBooks(query):
                guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    state.searchResults = []
                    state.isSearching = false
                    return .none
                }

                state.isSearching = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        let results = try await bookService.searchBooks(query: query)
                        await send(.searchResultsLoaded(results))

                        if !results.isEmpty {
                            await bookService.addRecentSearch(query)
                        }
                    } catch {
                        await send(.searchFailed(error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.searchBooks, cancelInFlight: true)

            case let .searchResultsLoaded(results):
                state.searchResults = results
                state.isSearching = false
                return .none

            case let .searchFailed(error):
                state.isSearching = false
                state.errorMessage = error
                return .none

            case .clearSearchText:
                state.searchText = ""
                state.searchResults = []
                state.isSearching = false
                return .cancel(id: CancelID.searchDebounce)

            case let .recentSearchTapped(query):
                state.searchText = query
                return .send(.searchBooks(query))

            case let .removeRecentSearch(index):

                return .run { [recentSearches = state.recentSearches] send in
                    guard index < recentSearches.count else { return }
                    await bookService.removeRecentSearch(at: index)
                    await send(.recentSearchRemoved(index))
                }

            case let .recentSearchRemoved(index):
                guard index < state.recentSearches.count else { return .none }
                state.recentSearches.remove(at: index)
                return .none

            case let .genreTapped(genre):
                let query = "жанр: \(genre)"
                state.searchText = query
                return .send(.searchBooks(query))

            case let .authorTapped(author):
                let query = "автор: \(author.name)"
                state.searchText = query
                return .send(.searchBooks(query))

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

            case .clearError:
                state.errorMessage = nil
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
