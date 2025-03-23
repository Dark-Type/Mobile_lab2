//
//  MainView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct MainView: View {
    // MARK: - State

    @State private var selectedTab = 0
    @State private var isReadingScreenPresented = false
    @State private var selectedBookForReading: Book? = nil
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    @AppStorage("currentBookID") private var currentBookID: String = ""
    @AppStorage("favoriteBookIDs") private var favoriteBookIDsString: String = ""
    @State private var showNoBookAlert = false

    // MARK: - Computed Properties

    var currentBook: Book? {
        guard !currentBookID.isEmpty else { return nil }
        return MockData.books.first { $0.id.uuidString == currentBookID }
    }

    private var favoriteBookIDs: [String] {
        favoriteBookIDsString.isEmpty ? [] : favoriteBookIDsString.split(separator: ",").map(String.init)
    }

    var favoriteBooks: [Book] {
        let ids = favoriteBookIDs
        return MockData.books.filter { book in
            ids.contains(book.id.uuidString)
        }
    }

    // MARK: - View

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                LibraryScreen(
                    isFavorite: isFavorite(_:),
                    setCurrentBook: setCurrentBook,
                    toggleFavorite: toggleFavorite
                )
                .tag(0)

                SearchScreen(
                    isFavorite: isFavorite(_:),
                    setCurrentBook: setCurrentBook,
                    toggleFavorite: toggleFavorite
                )
                .tag(1)

                BookmarksScreen(
                    currentBook: currentBook,
                    favoriteBooks: favoriteBooks,
                    setCurrentBook: setCurrentBook,
                    toggleFavorite: toggleFavorite
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .background(AppColors.background.color)
            .safeAreaInset(edge: .bottom) {
                CustomTabBar(
                    selectedTab: $selectedTab,
                    readingAction: handleReadingAction,
                    logoutAction: performLogout
                )
            }
        }
        .fullScreenCover(isPresented: $isReadingScreenPresented) {
            if let book = currentBook {
                NavigationStack {
                    ReadingScreen(
                        book: book,
                        setCurrentBook: setCurrentBook,
                        isFavorite: isFavorite(book),
                        toggleFavorite: { toggleFavorite(book) }
                    )
                    .toolbarBackground(Color.clear, for: .navigationBar)
                }
            }
        }
        .fullScreenCover(item: $selectedBookForReading) { book in
            NavigationStack {
                ReadingScreen(
                    book: book,
                    setCurrentBook: setCurrentBook,
                    isFavorite: isFavorite(book),
                    toggleFavorite: { toggleFavorite(book) }
                )
                .toolbarBackground(Color.clear, for: .navigationBar)
            }
        }
        .alert("No Book Selected", isPresented: $showNoBookAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please select a book from the Library or Search to start reading.")
        }
        .onChange(of: favoriteBookIDsString) { newValue in
            print("Favorite books updated: \(newValue)")
        }
    }

    // MARK: - Actions

    func setCurrentBook(_ book: Book) {
        currentBookID = book.id.uuidString
    }

    private func handleReadingAction() {
        if currentBook != nil {
            isReadingScreenPresented = true
        } else {
            showNoBookAlert = true
        }
    }

    private func performLogout() {
        withAnimation {
            isLoggedIn = false
        }
    }

    func toggleFavorite(_ book: Book) {
        let bookID = book.id.uuidString
        var ids = favoriteBookIDs

        if ids.contains(bookID) {
            ids.removeAll { $0 == bookID }
        } else {
            ids.append(bookID)
        }

        favoriteBookIDsString = ids.joined(separator: ",")
        print("Toggled favorite for \(book.title), favoriteBookIDsString now: \(favoriteBookIDsString)")
    }

    func isFavorite(_ book: Book) -> Bool {
        favoriteBookIDs.contains(book.id.uuidString)
    }
}

// MARK: - Preview

#Preview {
    MainView()
}
