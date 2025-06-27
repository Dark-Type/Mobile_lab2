//
//  SearchEmptyStateView.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

import ComposableArchitecture
import SwiftUI

struct SearchEmptyStateView: View {
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: SearchViewMetrics.mainSpacing) {
                RecentSearchesSection(viewStore: viewStore)
                GenresGridSection(viewStore: viewStore)
                AuthorsSection(viewStore: viewStore)
            }
        }
    }
}

// MARK: - Recent Searches Section

private struct RecentSearchesSection: View {
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: SearchViewMetrics.sectionSpacing) {
                SectionTitle(title: L10n.Search.recent)
                    .accessibilityIdentifier(AccessibilityIdentifiers.recentSearchesTitle.rawValue)

                if viewStore.hasRecentSearches {
                    RecentSearchesList(viewStore: viewStore)
                } else {
                    EmptyRecentSearchesView()
                }
            }
        }
    }
}

// MARK: - Recent Searches List

private struct RecentSearchesList: View {
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: SearchViewMetrics.itemSpacing) {
                ForEach(viewStore.recentSearches.indices, id: \.self) { index in
                    LastRequestItemCard(
                        request: viewStore.recentSearches[index],
                        onDelete: {
                            viewStore.send(.removeRecentSearch(index))
                        }
                    )
                    .accessibilityIdentifier("\(AccessibilityIdentifiers.recentSearchItem.rawValue)_\(index)")
                    .onTapGesture {
                        viewStore.send(.recentSearchTapped(viewStore.recentSearches[index]))
                    }
                }
            }
        }
    }
}

// MARK: - Genres Grid Section

private struct GenresGridSection: View {
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: SearchViewMetrics.itemSpacing) {
                SectionTitle(title: L10n.Search.genres)
                    .accessibilityIdentifier(AccessibilityIdentifiers.genresSectionTitle.rawValue)

                if viewStore.hasGenres {
                    GenresGrid(viewStore: viewStore)
                } else {
                    EmptyGenresView()
                }
            }
        }
    }
}

// MARK: - Genres Grid

private struct GenresGrid: View {
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>

    var body: some View {
        WithPerceptionTracking {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(minimum: SearchViewMetrics.gridMinimumItemWidth), spacing: SearchViewMetrics.gridSpacing),
                    GridItem(.flexible(minimum: SearchViewMetrics.gridMinimumItemWidth), spacing: SearchViewMetrics.gridSpacing)
                ],
                spacing: SearchViewMetrics.gridSpacing
            ) {
                ForEach(viewStore.genres, id: \.self) { genre in
                    GenreCard(genre: genre)
                        .accessibilityIdentifier("\(AccessibilityIdentifiers.genreCard.rawValue)_\(genre.lowercased().replacingOccurrences(of: " ", with: "_"))")
                        .onTapGesture {
                            viewStore.send(.genreTapped(genre))
                        }
                }
            }
        }
    }
}

// MARK: - Authors Section

private struct AuthorsSection: View {
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: SearchViewMetrics.sectionSpacing) {
                SectionTitle(title: L10n.Search.authors)
                    .accessibilityIdentifier(AccessibilityIdentifiers.authorsSectionTitle.rawValue)

                if viewStore.hasAuthors {
                    AuthorsList(viewStore: viewStore)
                } else {
                    EmptyAuthorsView()
                }
            }
        }
    }
}

// MARK: - Authors List

private struct AuthorsList: View {
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: SearchViewMetrics.itemSpacing) {
                ForEach(viewStore.authors) { author in
                    AuthorCard(author: author)
                        .accessibilityIdentifier("\(AccessibilityIdentifiers.authorCard.rawValue)_\(author.id)")
                        .onTapGesture {
                            viewStore.send(.authorTapped(author))
                        }
                }
            }
        }
    }
}

// MARK: - Section Title

private struct SectionTitle: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .appFont(.header2)
            .foregroundColor(.accentDark)
    }
}

#Preview {
    SearchEmptyStateView(
        viewStore: ViewStore(
            Store(initialState: SearchFeature.State()) {
                SearchFeature()
            },
            observe: { $0 }
        )
    )
}
