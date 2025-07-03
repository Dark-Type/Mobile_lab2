//
//  LibraryView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct LibraryView: View {
    let store: StoreOf<LibraryFeature>
    let isFavorite: (BookUI) -> Bool

    var body: some View {
        WithPerceptionTracking {
            WithViewStore(store, observe: { $0 }, content: { viewStore in
                LibraryContentView(
                    viewStore: viewStore,
                    isFavorite: isFavorite
                )
            })
        }
    }
}

// MARK: - Main Content View

private struct LibraryContentView: View {
    let viewStore: ViewStore<LibraryFeature.State, LibraryFeature.Action>
    let isFavorite: (BookUI) -> Bool

    // MARK: - Constants

    private enum ViewMetrics {
        static let verticalSpacing: CGFloat = 24
        static let sectionSpacing: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 24
        static let gridSpacing: CGFloat = 20
        static let gridItemSpacing: CGFloat = 16
        static let gridColumnsCount: Int = 3
        static let carouselItemScale: CGFloat = 0.7
        static let carouselSideItemScale: CGFloat = 0.12
        static let carouselSpacing: CGFloat = 20
        static let carouselHeightPadding: CGFloat = 16
    }

    var body: some View {
        WithPerceptionTracking {
            GeometryReader { screenGeometry in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: ViewMetrics.verticalSpacing) {
                        headerView

                        if viewStore.isLoading {
                            loadingView
                        } else if let errorMessage = viewStore.errorMessage {
                            errorView(errorMessage)
                        } else {
                            newBooksSection(screenHeight: screenGeometry.size.height)
                            popularBooksSection(screenWidth: screenGeometry.size.width)
                        }
                    }
                    .padding(.top, ViewMetrics.topPadding)
                }
                .scrollContentBackground(.hidden)
                .background(AppColors.background.color)
                .accessibilityIdentifier(AccessibilityIdentifiers.libraryScreenView.rawValue)
            }
            .setupFullScreenCovers(viewStore: viewStore, isFavorite: isFavorite)
            .onAppear {
                viewStore.send(.viewAppeared)
            }
        }
    }

    // MARK: - View Components

    private var headerView: some View {
        Text(L10n.Library.title.uppercased())
            .appFont(.header1)
            .foregroundColor(.secondaryRed)
            .padding(.horizontal, ViewMetrics.horizontalPadding)
            .accessibilityIdentifier(AccessibilityIdentifiers.libraryTitle.rawValue)
    }

    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading books...")
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
            Text("Error loading books")
                .appFont(.header2)
                .foregroundColor(.accentDark)
            Text(message)
                .appFont(.body)
                .foregroundColor(.accentDark)
                .multilineTextAlignment(.center)
            Button("Retry") {
                viewStore.send(.loadBooks)
            }
            .foregroundColor(.secondaryRed)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 100)
    }

    private func newBooksSection(screenHeight: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: ViewMetrics.sectionSpacing) {
            Text(L10n.Library.new.uppercased())
                .appFont(.header2)
                .foregroundColor(.accentDark)
                .padding(.horizontal, ViewMetrics.horizontalPadding)
                .accessibilityIdentifier(AccessibilityIdentifiers.newBooksTitle.rawValue)

            carouselView(books: viewStore.featuredBooks, screenHeight: screenHeight)
        }
    }

    private func popularBooksSection(screenWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: ViewMetrics.sectionSpacing * 2) {
            Text(L10n.Library.popular.uppercased())
                .appFont(.header2)
                .foregroundColor(.accentDark)
                .padding(.horizontal, ViewMetrics.horizontalPadding)
                .accessibilityIdentifier(AccessibilityIdentifiers.popularBooksTitle.rawValue)

            booksGridView(books: viewStore.popularBooks, screenWidth: screenWidth)
        }
        .padding(.bottom, ViewMetrics.bottomPadding)
    }

    private func carouselView(books: [BookUI], screenHeight: CGFloat) -> some View {
        let itemWidth = UIScreen.main.bounds.width * ViewMetrics.carouselItemScale
        let itemHeight = itemWidth
        let sideItemWidth = UIScreen.main.bounds.width * ViewMetrics.carouselSideItemScale

        if books.isEmpty {
            return AnyView(
                Text("No featured books available")
                    .appFont(.header2)
                    .foregroundColor(.accentDark)
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .background(Color.clear)
                    .accessibilityIdentifier(AccessibilityIdentifiers.emptyCarouselMessage.rawValue)
            )
        } else {
            return AnyView(
                ScrollView(.horizontal, showsIndicators: false) {
                    WithPerceptionTracking {
                        HStack(spacing: ViewMetrics.carouselSpacing) {
                            ForEach(books) { book in
                                CarouselItemView(book: book) {
                                    viewStore.send(.bookSelectedForReading(book))
                                }
                                .frame(width: itemWidth, height: itemHeight)
                                .accessibilityIdentifier("\(AccessibilityIdentifiers.carouselItem.rawValue)\(book.id)")
                            }
                        }
                        .padding(.horizontal, sideItemWidth)
                    }
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.booksCarousel.rawValue)
                .frame(height: itemHeight + ViewMetrics.carouselHeightPadding)
            )
        }
    }

    private func booksGridView(books: [BookUI], screenWidth: CGFloat) -> some View {
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: ViewMetrics.gridItemSpacing),
            count: ViewMetrics.gridColumnsCount
        )

        if books.isEmpty {
            return AnyView(
                Text("No popular books available")
                    .appFont(.header2)
                    .foregroundColor(.accentDark)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 50)
                    .accessibilityIdentifier(AccessibilityIdentifiers.emptyGridMessage.rawValue)
            )
        } else {
            return AnyView(

                WithPerceptionTracking {
                    LazyVGrid(columns: columns, spacing: ViewMetrics.gridSpacing) {
                        ForEach(books) { book in
                            BookCard(
                                book: book,
                                width: (screenWidth - (ViewMetrics.horizontalPadding * 2) -
                                    (ViewMetrics.gridItemSpacing * CGFloat(ViewMetrics.gridColumnsCount - 1))) /
                                    CGFloat(ViewMetrics.gridColumnsCount),
                                height: 270,
                                action: {
                                    viewStore.send(.bookSelectedForReading(book))
                                }
                            )
                            .accessibilityIdentifier("\(AccessibilityIdentifiers.bookCard.rawValue)\(book.id)")
                        }
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.booksGrid.rawValue)
                    .background(Color.clear)
                    .padding(.horizontal, ViewMetrics.horizontalPadding)
                }
            )
        }
    }
}

// MARK: - View Modifiers

private extension View {
    func setupFullScreenCovers(
        viewStore: ViewStore<LibraryFeature.State, LibraryFeature.Action>,
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
    LibraryView(
        store: Store(initialState: LibraryFeature.State()) {
            LibraryFeature()
        },
        isFavorite: { _ in false }
    )
}
