//
//  SearchView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct SearchView: View {
    let store: StoreOf<SearchFeature>
    let isFavorite: (Book) -> Bool

    var body: some View {
        WithPerceptionTracking {
            WithViewStore(store, observe: { $0 }, content: { viewStore in
                SearchContentView(
                    viewStore: viewStore,
                    store: store,
                    isFavorite: isFavorite
                )
            })
        }
    }
}

// MARK: - Main Content View

private struct SearchContentView: View {
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>
    let store: StoreOf<SearchFeature>
    let isFavorite: (Book) -> Bool

    var body: some View {
        WithPerceptionTracking {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SearchViewMetrics.mainSpacing) {
                    SearchBarView(viewStore: viewStore)

                    SearchContentStateView(viewStore: viewStore, isFavorite: isFavorite)
                }
                .padding(.top, SearchViewMetrics.topPadding)
                .padding(.horizontal)
            }
            .scrollContentBackground(.hidden)
            .background(AppColors.background.color)
            .setupFullScreenCovers(viewStore: viewStore, store: store, isFavorite: isFavorite)
            .onAppear {
                viewStore.send(.viewAppeared)
            }
        }
    }
}

// MARK: - Content State Handler

private struct SearchContentStateView: View {
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>
    let isFavorite: (Book) -> Bool

    var body: some View {
        WithPerceptionTracking {
            if viewStore.isLoadingInitialData {
                SearchLoadingView()
            } else if let errorMessage = viewStore.errorMessage {
                SearchErrorView(message: errorMessage, viewStore: viewStore)
            } else if viewStore.isSearchTextEmpty {
                SearchEmptyStateView(viewStore: viewStore)
            } else {
                SearchResultsView(viewStore: viewStore)
            }
        }
    }
}

// MARK: - View Modifiers

private extension View {
    func setupFullScreenCovers(
        viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>,
        store: StoreOf<SearchFeature>,
        isFavorite: @escaping (Book) -> Bool
    ) -> some View {
        self.fullScreenCover(item: .init(
            get: { viewStore.selectedBookForReading },
            set: { viewStore.send(.bookSelectedForReading($0)) }
        )) { book in
            WithPerceptionTracking {
                NavigationStack {
                    ReadingView(
                        store: Store(
                            initialState: ReadingFeature.State(book: book, isFavorite: isFavorite(book))
                        ) {
                            ReadingFeature()
                        }
                    )
                    .accessibilityIdentifier(AccessibilityIdentifiers.readingScreen.rawValue)
                    .toolbarBackground(Color.clear, for: ToolbarPlacement.navigationBar)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SearchView(
        store: Store(initialState: SearchFeature.State()) {
            SearchFeature()
        },
        isFavorite: { _ in false }
    )
}
