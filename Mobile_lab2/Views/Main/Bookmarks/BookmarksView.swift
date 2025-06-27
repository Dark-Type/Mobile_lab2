//
//  BookmarksView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct BookmarksView: View {
    let store: StoreOf<BookmarksFeature>
    let isFavorite: (Book) -> Bool

    var body: some View {
        WithPerceptionTracking {
            WithViewStore(store, observe: { $0 }, content: { viewStore in
                BookmarksContentView(
                    viewStore: viewStore,
                    isFavorite: isFavorite
                )
            })
        }
    }
}

// MARK: - Main Content View

private struct BookmarksContentView: View {
    let viewStore: ViewStore<BookmarksFeature.State, BookmarksFeature.Action>
    let isFavorite: (Book) -> Bool

    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    titleView

                    if viewStore.isLoading {
                        loadingView
                    } else if let errorMessage = viewStore.errorMessage {
                        errorView(errorMessage)
                    } else {
                        mainContent
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
            .scrollContentBackground(.hidden)
            .background(AppColors.background.color)
            .setupFullScreenCovers(viewStore: viewStore, isFavorite: isFavorite)
            .onAppear {
                viewStore.send(.viewAppeared)
            }
        }
    }

    // MARK: - Header

    private var titleView: some View {
        Text(L10n.Bookmarks.title.uppercased())
            .appFont(.header1)
            .foregroundColor(.secondaryRed)
            .padding(.horizontal)
            .accessibilityIdentifier(AccessibilityIdentifiers.bookmarksTitle.rawValue)
    }

    // MARK: - Loading and Error States

    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading bookmarks...")
                .appFont(.body)
                .foregroundColor(.accentDark)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 100)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Error loading bookmarks")
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

    // MARK: - Main Content

    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            if viewStore.hasCurrentlyReadingBooks {
                currentlyReadingSection
            }

            if viewStore.hasFavoriteBooks {
                favoriteBooksSection
            } else {
                emptyFavoriteBooksSection
            }

            if viewStore.hasQuotes {
                quotesSection
            } else {
                emptyQuotesSection
            }
        }
    }
}

// MARK: - Content Sections

extension BookmarksContentView {

    // MARK: - Currently Reading Section

    private var currentlyReadingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center) {
                Text(L10n.Bookmarks.current.uppercased())
                    .appFont(.header2)
                    .foregroundColor(.accentDark)
                    .accessibilityIdentifier(AccessibilityIdentifiers.currentReadingSectionTitle.rawValue)

                Spacer()

                if let topBook = viewStore.topCurrentBook {
                    continueReadingButton(for: topBook)
                }
            }
            .padding(.horizontal)

            WithPerceptionTracking {
                VStack(spacing: 16) {
                    ForEach(viewStore.currentlyReadingBooks) { book in
                        BookmarkListItem(
                            book: book,
                            isCurrent: true,
                            startReadingAction: {
                                viewStore.send(.continueReading(book))
                            },
                            openBookDetailsAction: {
                                viewStore.send(.bookSelectedForReading(book))
                            }
                        )
                        .accessibilityIdentifier("\(AccessibilityIdentifiers.currentReadingBookItem.rawValue)_\(book.id)")
                    }
                }
            }
        }
    }

    private func continueReadingButton(for book: Book) -> some View {
        Button(action: {
            viewStore.send(.continueReading(book))
        }, label: {
            ZStack {
                Circle()
                    .fill(AppColors.accentDark.color)
                    .frame(width: 40, height: 40)
                AppIcons.play.image
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 16, height: 16)
            }
        })
        .buttonStyle(PlainButtonStyle())
        .accessibilityIdentifier(AccessibilityIdentifiers.continueReadingButton.rawValue)
    }

    // MARK: - Favorite Books Section

    private var favoriteBooksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Bookmarks.favorite.uppercased())
                .appFont(.header2)
                .foregroundColor(.accentDark)
                .padding(.horizontal)
                .accessibilityIdentifier(AccessibilityIdentifiers.favoriteBooksSectionTitle.rawValue)

            WithPerceptionTracking {
                VStack(spacing: 16) {
                    ForEach(viewStore.favoriteBooks) { book in
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
                        .accessibilityIdentifier("\(AccessibilityIdentifiers.favoriteBookItem.rawValue)_\(book.id)")
                    }
                }
            }
        }
    }

    private var emptyFavoriteBooksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Bookmarks.favorite.uppercased())
                .appFont(.header2)
                .foregroundColor(.accentDark)
                .padding(.horizontal)
                .accessibilityIdentifier(AccessibilityIdentifiers.favoriteBooksSectionTitle.rawValue)

            emptyStateCard(
                message: "У вас нет избранных книг",
                description: "Добавляйте книги в избранное, чтобы быстро находить их здесь"
            )
            .accessibilityIdentifier(AccessibilityIdentifiers.emptyFavoriteBooksView.rawValue)
        }
    }

    // MARK: - Quotes Section

    private var quotesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Bookmarks.quotes.uppercased())
                .appFont(.header2)
                .foregroundColor(.accentDark)
                .padding(.horizontal)
                .accessibilityIdentifier(AccessibilityIdentifiers.quotesSectionTitle.rawValue)

            WithPerceptionTracking {
                VStack(spacing: 16) {
                    ForEach(viewStore.quotes) { quote in
                        QuoteCard(quote: quote)
                            .padding(.horizontal)
                            .accessibilityIdentifier("\(AccessibilityIdentifiers.quoteItem.rawValue)_\(quote.id)")
                    }
                }
            }
        }
    }

    private var emptyQuotesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Bookmarks.quotes.uppercased())
                .appFont(.header2)
                .foregroundColor(.accentDark)
                .padding(.horizontal)
                .accessibilityIdentifier(AccessibilityIdentifiers.quotesSectionTitle.rawValue)

            emptyStateCard(
                message: "У вас нет сохраненных цитат",
                description: "Сохраняйте понравившиеся цитаты во время чтения"
            )
            .accessibilityIdentifier(AccessibilityIdentifiers.emptyQuotesView.rawValue)
        }
    }

    // MARK: - Helper Views

    private func emptyStateCard(message: String, description: String) -> some View {
        VStack(spacing: 8) {
            Text(message)
                .appFont(.body)
                .foregroundColor(.accentDark)
                .multilineTextAlignment(.center)
            Text(description)
                .appFont(.header2)
                .foregroundColor(.accentMedium)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(AppColors.white.color.opacity(0.5))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - View Modifiers

private extension View {
    func setupFullScreenCovers(
        viewStore: ViewStore<BookmarksFeature.State, BookmarksFeature.Action>,
        isFavorite: @escaping (Book) -> Bool
    ) -> some View {
        self
            .fullScreenCover(item: .init(
                get: { viewStore.selectedBookForReading },
                set: { viewStore.send(.bookSelectedForReading($0)) }
            )) { book in
                WithPerceptionTracking {
                    NavigationStack {
                        ReadingScreen(
                            book: book,
                            setCurrentBook: { book in viewStore.send(.delegate(.setCurrentBook(book))) },
                            isFavorite: isFavorite(book),
                            toggleFavorite: { viewStore.send(.delegate(.toggleFavorite(book))) }
                        )
                        .accessibilityIdentifier(AccessibilityIdentifiers.readingScreen.rawValue)
                        .toolbarBackground(Color.clear, for: .navigationBar)
                    }
                }
            }
            .fullScreenCover(item: .init(
                get: {
                    if let selected = viewStore.selectedChapterForReading {
                        return ChapterSelection(book: selected.book, chapter: selected.chapter)
                    }
                    return nil
                },
                set: { _ in viewStore.send(.chapterReadingScreenDismissed) }
            )) { selection in
                WithPerceptionTracking {
                    NavigationStack {
                        ChapterReadingView(
                            book: selection.book,
                            setCurrentBook: { book in viewStore.send(.delegate(.setCurrentBook(book))) },
                            chapter: selection.chapter
                        )
                        .toolbarBackground(Color.clear, for: .navigationBar)
                    }
                }
            }
    }
}

// MARK: - Helper Types

private struct ChapterSelection: Identifiable, Equatable {
    let id = UUID()
    let book: Book
    let chapter: Chapter
}

// MARK: - Preview

#Preview {
    BookmarksView(
        store: Store(initialState: BookmarksFeature.State()) {
            BookmarksFeature()
        },
        isFavorite: { _ in false }
    )
}
