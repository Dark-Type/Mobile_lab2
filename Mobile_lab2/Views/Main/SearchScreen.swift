//
//  SearchView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct SearchScreen: View {
    // MARK: - State

    @State private var searchText = ""
    @State private var recentSearches = ["Android", "Чистый код", "Чистая Архитектура", "Advanced Swift", "iOS"]
    @State private var isSearchActive = false
    @State private var selectedBook: Book? = nil
    @State private var showingBookDetail = false
    @State private var isReadingScreenPresented = false
    private let genres = MockData.genres
    private let authors = MockData.authors
    
    // MARK: - Properties

    let isFavorite: (Book) -> Bool
    let setCurrentBook: (Book) -> Void
    let toggleFavorite: (Book) -> Void
    
    // MARK: - Initializer

    init(isFavorite: @escaping (Book) -> Bool = { _ in false }, setCurrentBook: @escaping (Book) -> Void = { _ in },
         toggleFavorite: @escaping (Book) -> Void = { _ in })
    {
        self.isFavorite = isFavorite
        self.setCurrentBook = setCurrentBook
        self.toggleFavorite = toggleFavorite
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                self.customSearchBar
                       
                if self.searchText.isEmpty {
                    self.recentSearchesSection
                    self.genresGridSection
                    self.authorsSection
                } else {
                    self.searchResultsSection
                }
            }
            .padding(.top, 16)
            .padding(.horizontal)
        }
        .scrollContentBackground(.hidden)
        .background(AppColors.background.color)
        .fullScreenCover(item: self.$selectedBook) { book in
            NavigationStack {
                ReadingScreen(
                    book: book,
                    setCurrentBook: self.setCurrentBook,
                    isFavorite: self.isFavorite(book),
                    toggleFavorite: { self.toggleFavorite(book) }
                )
                .toolbarBackground(Color.clear, for: .navigationBar)
            }
        }
    }
         
    // MARK: - UI Components
    
    private var customSearchBar: some View {
        HStack {
            HStack {
                AppIcons.search.image
                    .renderingMode(.template)
                    .foregroundColor(.accentDark)
                
                TextField("", text: self.$searchText)
                    .appFont(.body)
                    .foregroundStyle(.accentDark)
                    .placeholder(when: self.searchText.isEmpty) {
                        Text(L10n.Search.searchViewText)
                            .appFont(.body)
                            .foregroundStyle(.accentMedium)
                    }
                
                if !self.searchText.isEmpty {
                    Button(action: {
                        self.searchText = ""
                    }) {
                        AppIcons.close.image
                            .renderingMode(.template)
                            .foregroundColor(.accentDark)
                    }
                }
            }
            .padding(12)
            .background(AppColors.white.color)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.accentMedium.color, lineWidth: 1)
            )
            .cornerRadius(12)
        }
    }

    private var recentSearchesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Search.recent.uppercased())
                .appFont(.h2)
                .foregroundColor(.accentDark)
            
            VStack(spacing: 12) {
                ForEach(self.recentSearches.indices, id: \.self) { index in
                    LastRequestItemCard(
                        request: self.recentSearches[index],
                        onDelete: {
                            self.recentSearches.remove(at: index)
                        }
                    )
                    .onTapGesture {
                        self.searchText = self.recentSearches[index]
                    }
                }
            }
        }
    }
    
    private var genresGridSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.Search.genres.uppercased())
                .appFont(.h2)
                .foregroundColor(.accentDark)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(minimum: 140), spacing: 12),
                    GridItem(.flexible(minimum: 140), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(self.genres, id: \.self) { genre in
                    GenreCard(genre: genre)
                        .onTapGesture {
                            self.searchText += "жанр: \(genre)"
                        }
                }
            }
        }
    }
    
    private var authorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Search.authors.uppercased())
                .appFont(.h2)
                .foregroundColor(.accentDark)
            
            VStack(spacing: 12) {
                ForEach(self.authors) { author in
                    AuthorCard(author: author)
                        .onTapGesture {
                            self.searchText += "автор: \(author.name)"
                        }
                }
            }
        }
    }
    
    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(spacing: 16) {
                ForEach(MockData.books) { book in
                    BookmarkListItem(
                        book: book,
                        isCurrent: false,
                        startReadingAction: {
                            self.openBookDetail(book)
                        },
                        openBookDetailsAction: {
                            self.openBookDetail(book)
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private func openBookDetail(_ book: Book) {
        self.selectedBook = book
        self.isReadingScreenPresented = true
    }
}

#Preview {
    SearchScreen()
}
