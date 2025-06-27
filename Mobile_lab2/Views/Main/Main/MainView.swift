//
//  MainView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    let store: StoreOf<MainFeature>

    var body: some View {
        WithPerceptionTracking {
            WithViewStore(store, observe: { $0 }, content: { viewStore in
                MainContentView(viewStore: viewStore)
            })
        }
    }
}

// MARK: - Main Content View

private struct MainContentView: View {
    let viewStore: ViewStore<MainFeature.State, MainFeature.Action>

    var body: some View {
        ZStack {
            AppColors.background.color
                .ignoresSafeArea()

            mainTabView
        }
        .setupFullScreenCovers(viewStore: self.viewStore)
        .setupAlerts(viewStore: self.viewStore)
        .onAppear {
            viewStore.send(.viewAppeared)
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.mainView.rawValue)
    }

    private var mainTabView: some View {
        TabView(selection: .init(
            get: { viewStore.selectedTab },
            set: { viewStore.send(.tabSelected($0)) }
        )) {
            libraryTab
            searchTab
            bookmarksTab
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .safeAreaInset(edge: .bottom) {
            CustomTabBar(
                selectedTab: .init(
                    get: { viewStore.selectedTab },
                    set: { viewStore.send(.tabSelected($0)) }
                ),
                readingAction: { viewStore.send(.readingButtonTapped) },
                logoutAction: { viewStore.send(.logoutButtonTapped) }
            )
        }
    }

    private var libraryTab: some View {
        LibraryScreen(
            isFavorite: { book in viewStore.state.isFavorite(book) },
            setCurrentBook: { book in viewStore.send(.setCurrentBook(book)) },
            toggleFavorite: { book in viewStore.send(.toggleFavorite(book)) }
        )
        .tag(0)
        .toolbarBackground(.hidden, for: .tabBar)
    }

    private var searchTab: some View {
        SearchScreen(
            isFavorite: { book in viewStore.state.isFavorite(book) },
            setCurrentBook: { book in viewStore.send(.setCurrentBook(book)) },
            toggleFavorite: { book in viewStore.send(.toggleFavorite(book)) }
        )
        .tag(1)
        .toolbarBackground(.hidden, for: .tabBar)
    }

    private var bookmarksTab: some View {
        BookmarksScreen(
            currentBook: viewStore.currentBook,
            favoriteBooks: viewStore.favoriteBooks,
            setCurrentBook: { book in viewStore.send(.setCurrentBook(book)) },
            toggleFavorite: { book in viewStore.send(.toggleFavorite(book)) }
        )
        .tag(2)
        .toolbarBackground(.hidden, for: .tabBar)
    }
}

// MARK: - View Modifiers

private extension View {
    func setupFullScreenCovers(viewStore: ViewStore<MainFeature.State, MainFeature.Action>) -> some View {
        self
            .fullScreenCover(isPresented: .init(
                get: { viewStore.isReadingScreenPresented },
                set: { _ in viewStore.send(.readingScreenDismissed) }
            )) {
                CurrentBookReadingView(viewStore: viewStore)
            }
            .fullScreenCover(item: .init(
                get: { viewStore.selectedBookForReading },
                set: { viewStore.send(.bookSelectedForReading($0)) }
            )) { book in
                SelectedBookReadingView(book: book, viewStore: viewStore)
            }
    }

    func setupAlerts(viewStore: ViewStore<MainFeature.State, MainFeature.Action>) -> some View {
        self
            .alert("No Book Selected", isPresented: .init(
                get: { viewStore.showNoBookAlert },
                set: { _ in viewStore.send(.noBookAlertDismissed) }
            )) {
                Button("OK", role: .cancel) {
                    viewStore.send(.noBookAlertDismissed)
                }
            } message: {
                Text("Please select a book from the Library or Search to start reading.")
            }
    }
}

// MARK: - Reading Views

private struct CurrentBookReadingView: View {
    let viewStore: ViewStore<MainFeature.State, MainFeature.Action>

    var body: some View {
        Group {
            if let book = viewStore.currentBook {
                NavigationStack {
                    ReadingScreen(
                        book: book,
                        setCurrentBook: { book in
                            viewStore.send(.setCurrentBook(book)) },
                        isFavorite: viewStore.state.isFavorite(book),
                        toggleFavorite: { viewStore.send(.toggleFavorite(book)) }
                    )
                    .toolbarBackground(.clear, for: .navigationBar)
                }
            }
        }
    }
}

private struct SelectedBookReadingView: View {
    let book: Book
    let viewStore: ViewStore<MainFeature.State, MainFeature.Action>

    var body: some View {
        NavigationStack {
            ReadingScreen(
                book: book,
                setCurrentBook: { book in viewStore.send(.setCurrentBook(book)) },
                isFavorite: viewStore.state.isFavorite(book),
                toggleFavorite: { viewStore.send(.toggleFavorite(book)) }
            )
            .toolbarBackground(.clear, for: .navigationBar)
        }
    }
}

// MARK: - Preview

#Preview {
    MainView(store: Store(initialState: MainFeature.State()) {
        MainFeature()
    })
}
