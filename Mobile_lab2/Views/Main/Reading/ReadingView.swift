//
//  ReadingView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct ReadingView: View {
    let store: StoreOf<ReadingFeature>
    var onSetCurrentBook: ((BookUI) -> Void)? = nil
    var onToggleFavorite: ((BookUI) -> Void)? = nil

    var body: some View {
        WithPerceptionTracking {
            WithViewStore(store, observe: { $0 }, content: { viewStore in
                ReadingContentView(
                    viewStore: viewStore,
                    store: store,
                    onSetCurrentBook: onSetCurrentBook,
                    onToggleFavorite: onToggleFavorite
                )
            })
        }
    }
}

// MARK: - Main Content View

private struct ReadingContentView: View {
    let viewStore: ViewStore<ReadingFeature.State, ReadingFeature.Action>
    let store: StoreOf<ReadingFeature>
    let onSetCurrentBook: ((BookUI) -> Void)?
    let onToggleFavorite: ((BookUI) -> Void)?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        WithPerceptionTracking {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: ViewMetrics.spacing) {
                    posterView
                    actionButtons
                    bookInfoSection
                    if viewStore.book.userProgress.currentChapter != 0 {
                        readingProgressSection
                    }
                    chaptersSection
                }
                .padding(.bottom, ViewMetrics.bottomPadding)
                .background(AppColors.background.color)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.readingScreen.rawValue)
            .toolbarBackground(.hidden, for: .navigationBar)
            .ignoresSafeArea(.all)
            .setupFullScreenCovers(viewStore: viewStore, onSetCurrentBook: onSetCurrentBook)

        }
    }

    // MARK: - Constants

    private enum ViewMetrics {
        static let spacing: CGFloat = 24
        static let buttonSpacing: CGFloat = 10
        static let cornerRadius: CGFloat = 12
        static let buttonCornerRadius: CGFloat = 10
        static let contentSpacing: CGFloat = 8
        static let headerSpacing: CGFloat = 16
        static let horizontalPadding: CGFloat = 16
        static let buttonHorizontalPadding: CGFloat = 20
        static let buttonVerticalPadding: CGFloat = 12
        static let posterOverlayTopOpacity: CGFloat = 0
        static let posterOverlayBottomOpacity: CGFloat = 1
        static let topButtonsPaddingTop: CGFloat = -45
        static let descriptionPaddingTop: CGFloat = 8
        static let progressBarPaddingTop: CGFloat = 8
        static let chaptersPaddingTop: CGFloat = 16
        static let bottomPadding: CGFloat = 32
        static let backButtonFontSize: CGFloat = 17
    }

    // MARK: - View Components

    private var posterView: some View {
        WithPerceptionTracking {
            viewStore.book.posterImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: AppColors.background.color
                                .opacity(ViewMetrics.posterOverlayTopOpacity), location: 0),
                            .init(color: AppColors.background.color
                                .opacity(ViewMetrics.posterOverlayBottomOpacity), location: 1)
                        ]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(ViewMetrics.cornerRadius)
                .accessibilityIdentifier(AccessibilityIdentifiers.bookPoster.rawValue)
        }
    }

    private var actionButtons: some View {
        WithPerceptionTracking {
            HStack(alignment: .center, spacing: ViewMetrics.buttonSpacing) {
                readButton
                favoriteButton
            }
            .padding(.horizontal, ViewMetrics.horizontalPadding)
            .padding(.top, ViewMetrics.topButtonsPaddingTop)
            .frame(maxWidth: .infinity)
        }
    }

    private var readButton: some View {
        WithPerceptionTracking {
            Button { viewStore.send(.readButtonTapped)
                       let chapter = viewStore.book.chapters[viewStore.book.userProgress.currentChapter]
                       onSetCurrentBook?(viewStore.book)
                   } label: {
                HStack {
                    AppIcons.play.image
                        .renderingMode(.template)
                    Text(L10n.Book.read)
                }
                .appFont(.body)
                .bold(true)
                .foregroundColor(AppColors.white.color)
                .padding(.horizontal, ViewMetrics.buttonHorizontalPadding)
                .padding(.vertical, ViewMetrics.buttonVerticalPadding)
                .frame(maxWidth: .infinity)
                .background(.accentDark)
                .cornerRadius(ViewMetrics.buttonCornerRadius)
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.readButton.rawValue)
        }
    }

    private var favoriteButton: some View {
        WithPerceptionTracking {
            Button {
                viewStore.send(.favoriteButtonTapped)
                onToggleFavorite?(viewStore.book)
            } label: {
                HStack {
                    AppIcons.bookmarks.image
                        .renderingMode(.template)
                    Text(viewStore.isFavorite ? "Убрать из избранного" : L10n.Book.favorites)
                }
                .appFont(.body)
                .bold()
                .foregroundColor(viewStore.isFavorite ? .accentLight : .accentDark)
                .padding(.horizontal, ViewMetrics.buttonHorizontalPadding)
                .padding(.vertical, ViewMetrics.buttonVerticalPadding)
                .frame(maxWidth: .infinity)
                .background(viewStore.isFavorite ? .secondaryRed : .accentLight)
                .cornerRadius(ViewMetrics.buttonCornerRadius)
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.favoriteButton.rawValue)
        }
    }

    private var bookInfoSection: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: ViewMetrics.contentSpacing) {
                Text(viewStore.book.title.uppercased())
                    .appFont(.header1)
                    .accessibilityIdentifier(AccessibilityIdentifiers.bookTitle.rawValue)
                Text(viewStore.book.author.map { $0.name }.joined(separator: ", "))
                    .appFont(.body)
                    .accessibilityIdentifier(AccessibilityIdentifiers.authorName.rawValue)
                Text(viewStore.book.description)
                    .appFont(.body)
                    .padding(.top, ViewMetrics.descriptionPaddingTop)
                    .accessibilityIdentifier(AccessibilityIdentifiers.bookDescription.rawValue)
            }
            .foregroundStyle(.accentDark)
            .padding(.horizontal, ViewMetrics.horizontalPadding)
        }
    }

    private var readingProgressSection: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: ViewMetrics.contentSpacing) {
                Text(L10n.Book.readBook.uppercased())
                    .appFont(.header2)
                    .foregroundStyle(.accentDark)
                ProgressBar(progress: viewStore.book.userProgress.overallProgress)
                    .accessibilityIdentifier(AccessibilityIdentifiers.progressBar.rawValue)
            }
            .padding(.horizontal, ViewMetrics.horizontalPadding)
            .padding(.top, ViewMetrics.progressBarPaddingTop)
        }
    }

    private var chaptersSection: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: ViewMetrics.headerSpacing) {
                Text(L10n.Book.contents.uppercased())
                    .appFont(.header2)
                    .foregroundStyle(.accentDark)
                    .accessibilityIdentifier(AccessibilityIdentifiers.contentsTitle.rawValue)
                ForEach(viewStore.book.chapters) { chapter in
                    ChapterListItem(
                        chapter: chapter,
                        action: {  viewStore.send(.chapterSelected(chapter))
                            onSetCurrentBook?(viewStore.book) },
                        showStatusIcon: true
                    )
                    .accessibilityIdentifier("\(AccessibilityIdentifiers.chapterListItem.rawValue)\(chapter.id)")
                }
            }
            .padding(.horizontal, ViewMetrics.horizontalPadding)
            .padding(.top, ViewMetrics.chaptersPaddingTop)
        }
    }

    private var backButton: some View {
        WithPerceptionTracking {
            Button(
                action: {
                    dismiss()
                },
                label: {
                    HStack {
                        AppIcons.arrowLeft.image
                        Text(L10n.Book.goBack)
                            .font(.system(size: ViewMetrics.backButtonFontSize, weight: .medium))
                            .foregroundStyle(AppColors.white.color)
                    }
                }
            )
            .accessibilityIdentifier(AccessibilityIdentifiers.backButton.rawValue)
        }
    }
}

// MARK: - View Modifiers

private extension View {
    func setupFullScreenCovers(
        viewStore: ViewStore<ReadingFeature.State, ReadingFeature.Action>,
        onSetCurrentBook: ((BookUI) -> Void)?
    ) -> some View {
        self.fullScreenCover(item: .init(
            get: { viewStore.selectedChapter },
            set: { _ in viewStore.send(.chapterReadingDismissed) }
        )) { chapter in
            WithPerceptionTracking {
                NavigationStack {
                    ChapterReadingView(
                        store: Store(
                            initialState: ChapterReadingFeature.State(
                                book: viewStore.book,
                                chapter: chapter,
                                shouldAutoStartReading: false
                            )
                        ) {
                            ChapterReadingFeature()
                        },
                        onSetCurrentBook: onSetCurrentBook
                    )
                    .toolbarBackground(Color.clear, for: ToolbarPlacement.navigationBar)
                }
            }
        }
    }
}
// MARK: - Preview

#Preview {
    NavigationStack {
        ReadingView(
            store: Store(initialState: ReadingFeature.State(book: MockData.books[0], isFavorite: false)) {
                ReadingFeature()
            }
        )
    }
}
