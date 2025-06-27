//
//  SearchLoadingView.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Loading View

struct SearchLoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading search data...")
                .appFont(.body)
                .foregroundColor(.accentDark)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 100)
    }
}

// MARK: - Error View

struct SearchErrorView: View {
    let message: String
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                Text("Error loading search data")
                    .appFont(.header2)
                    .foregroundColor(.accentDark)
                Text(message)
                    .appFont(.body)
                    .foregroundColor(.accentDark)
                    .multilineTextAlignment(.center)
                Button("Retry") {
                    viewStore.send(.loadInitialData)
                }
                .foregroundColor(.secondaryRed)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 100)
        }
    }
}

// MARK: - Search Results View

struct SearchResultsView: View {
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: SearchViewMetrics.sectionSpacing) {
                if viewStore.hasSearchResults {
                    SearchResultsListView(viewStore: viewStore)
                } else if !viewStore.isSearching {
                    SearchEmptyResultsView()
                }
            }
        }
    }
}

// MARK: - Search Results List

private struct SearchResultsListView: View {
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: SearchViewMetrics.sectionSpacing) {
                ForEach(viewStore.searchResults) { book in
                    BookmarkListItem(
                        book: book,
                        isCurrent: false,
                        startReadingAction: {
                            viewStore.send(.bookSelectedForReading(book))
                        },
                        openBookDetailsAction: {
                            viewStore.send(.bookSelectedForReading(book))
                        }
                    )
                    .accessibilityIdentifier("\(AccessibilityIdentifiers.searchResultItem.rawValue)_\(book.id)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

// MARK: - Empty Results View

private struct SearchEmptyResultsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.accentMedium)

            Text("Ничего не найдено")
                .appFont(.header2)
                .foregroundColor(.accentDark)
                .multilineTextAlignment(.center)

            Text("Попробуйте другие запросы")
                .appFont(.body)
                .foregroundColor(.accentMedium)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 50)
        .accessibilityIdentifier(AccessibilityIdentifiers.emptySearchResultsView.rawValue)
    }
}

#Preview("Loading") {
    SearchLoadingView()
}

#Preview("Error") {
    SearchErrorView(
        message: "Network error occurred",
        viewStore: ViewStore(
            Store(initialState: SearchFeature.State()) {
                SearchFeature()
            },
            observe: { $0 }
        )
    )
}
