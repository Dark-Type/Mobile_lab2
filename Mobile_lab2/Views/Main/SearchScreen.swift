//
//  SearchView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct SearchScreen: View {
    // MARK: - Constants
    
    private enum ViewMetrics {
        static let mainSpacing: CGFloat = 24
        static let sectionSpacing: CGFloat = 16
        static let itemSpacing: CGFloat = 12
        static let topPadding: CGFloat = 16
        static let cornerRadius: CGFloat = 12
        static let strokeWidth: CGFloat = 1
        static let searchBarPadding: CGFloat = 12
        static let gridMinimumItemWidth: CGFloat = 140
        static let gridSpacing: CGFloat = 12
    }
    
    // MARK: - State
    
    @State private var searchText = ""
    @State private var recentSearches = ["Android", "Чистый код", "Чистая Архитектура", "Advanced Swift", "iOS"]
    @State private var selectedBook: Book? = nil
    @State private var isReadingScreenPresented = false
    
    // MARK: - Properties
    
    private let genres = MockData.genres
    private let authors = MockData.authors
    let isFavorite: (Book) -> Bool
    let setCurrentBook: (Book) -> Void
    let toggleFavorite: (Book) -> Void
    
    // MARK: - Initializer
    
    init(
        isFavorite: @escaping (Book) -> Bool = { _ in false },
        setCurrentBook: @escaping (Book) -> Void = { _ in },
        toggleFavorite: @escaping (Book) -> Void = { _ in }
    ) {
        self.isFavorite = isFavorite
        self.setCurrentBook = setCurrentBook
        self.toggleFavorite = toggleFavorite
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ViewMetrics.mainSpacing) {
                searchBar
                
                if searchText.isEmpty {
                    recentSearchesSection
                    genresGridSection
                    authorsSection
                } else {
                    searchResultsSection
                }
            }
            .padding(.top, ViewMetrics.topPadding)
            .padding(.horizontal)
        }
        .scrollContentBackground(.hidden)
        .background(AppColors.background.color)
        .fullScreenCover(item: $selectedBook) { book in
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
    
    // MARK: - UI Components
    
    private var searchBar: some View {
        HStack {
            HStack {
                AppIcons.search.image
                    .renderingMode(.template)
                    .foregroundColor(.accentDark)
                
                TextField("", text: $searchText)
                    .appFont(.body)
                    .foregroundStyle(.accentDark)
                    .placeholder(when: searchText.isEmpty) {
                        Text(L10n.Search.searchViewText)
                            .appFont(.body)
                            .foregroundStyle(.accentMedium)
                    }
                
                if !searchText.isEmpty {
                    clearButton
                }
            }
            .padding(ViewMetrics.searchBarPadding)
            .background(AppColors.white.color)
            .overlay(
                RoundedRectangle(cornerRadius: ViewMetrics.cornerRadius)
                    .stroke(AppColors.accentMedium.color, lineWidth: ViewMetrics.strokeWidth)
            )
            .cornerRadius(ViewMetrics.cornerRadius)
        }
    }
    
    private var clearButton: some View {
        Button(action: {
            searchText = ""
        }) {
            AppIcons.close.image
                .renderingMode(.template)
                .foregroundColor(.accentDark)
        }
    }
    
    private var recentSearchesSection: some View {
        VStack(alignment: .leading, spacing: ViewMetrics.sectionSpacing) {
            sectionTitle(L10n.Search.recent)
            
            VStack(spacing: ViewMetrics.itemSpacing) {
                ForEach(recentSearches.indices, id: \.self) { index in
                    LastRequestItemCard(
                        request: recentSearches[index],
                        onDelete: {
                            recentSearches.remove(at: index)
                        }
                    )
                    .onTapGesture {
                        searchText = recentSearches[index]
                    }
                }
            }
        }
    }
    
    private var genresGridSection: some View {
        VStack(alignment: .leading, spacing: ViewMetrics.itemSpacing) {
            sectionTitle(L10n.Search.genres)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(minimum: ViewMetrics.gridMinimumItemWidth), spacing: ViewMetrics.gridSpacing),
                    GridItem(.flexible(minimum: ViewMetrics.gridMinimumItemWidth), spacing: ViewMetrics.gridSpacing)
                ],
                spacing: ViewMetrics.gridSpacing
            ) {
                ForEach(genres, id: \.self) { genre in
                    GenreCard(genre: genre)
                        .onTapGesture {
                            searchText += "жанр: \(genre)"
                        }
                }
            }
        }
    }
    
    private var authorsSection: some View {
        VStack(alignment: .leading, spacing: ViewMetrics.sectionSpacing) {
            sectionTitle(L10n.Search.authors)
            
            VStack(spacing: ViewMetrics.itemSpacing) {
                ForEach(authors) { author in
                    AuthorCard(author: author)
                        .onTapGesture {
                            searchText += "автор: \(author.name)"
                        }
                }
            }
        }
    }
    
    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: ViewMetrics.sectionSpacing) {
            VStack(spacing: ViewMetrics.sectionSpacing) {
                ForEach(MockData.books) { book in
                    BookmarkListItem(
                        book: book,
                        isCurrent: false,
                        startReadingAction: {
                            openBookDetail(book)
                        },
                        openBookDetailsAction: {
                            openBookDetail(book)
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .appFont(.h2)
            .foregroundColor(.accentDark)
    }
    
    private func openBookDetail(_ book: Book) {
        selectedBook = book
        isReadingScreenPresented = true
    }
}

#Preview {
    SearchScreen()
}
