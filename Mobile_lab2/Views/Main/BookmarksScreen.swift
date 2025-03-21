//
//  BookmarksView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct BookmarksScreen: View {
    // MARK: - State

    @State private var selectedBook: Book? = nil
    @State private var selectedChapter: Chapter? = nil
    
    // MARK: - Properties

    let currentBook: Book?
    let favoriteBooks: [Book]
    let setCurrentBook: (Book) -> Void
    let toggleFavorite: (Book) -> Void
    
    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                titleView
                   
                if let book = currentBook {
                    currentlyReadingSection(book: book)
                }
                   
                if !favoriteBooks.isEmpty {
                    favoriteBooksSection
                }
                   
                if !MockData.quotes.isEmpty {
                    quotesSection
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .scrollContentBackground(.hidden)
        .background(AppColors.background.color)
        .fullScreenCover(item: $selectedBook) { book in
            NavigationStack {
                ReadingScreen(
                    book: book,
                    setCurrentBook: setCurrentBook,
                    isFavorite: favoriteBooks.contains { $0.id == book.id },
                    toggleFavorite: { toggleFavorite(book) }
                )
                .toolbarBackground(Color.clear, for: .navigationBar)
            }
        }
        .fullScreenCover(item: $selectedChapter) { chapter in
            if let book = currentBook {
                NavigationStack {
                    ChapterReadingView(book: book, setCurrentBook: setCurrentBook, chapter: chapter)
                        .toolbarBackground(Color.clear, for: .navigationBar)
                }
            }
        }
    }

    // MARK: - UI Components
    
    private var titleView: some View {
        Text(L10n.Bookmarks.title.uppercased())
            .appFont(.h1)
            .foregroundColor(.secondaryRed)
            .padding(.horizontal)
    }
     
    private func currentlyReadingSection(book: Book) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center) {
                Text(L10n.Bookmarks.current.uppercased())
                    .appFont(.h2)
                    .foregroundColor(.accentDark)
                      
                Spacer()
                   
                continueReadingButton
            }
            .padding(.horizontal)
               
            BookmarkListItem(
                book: book,
                isCurrent: true,
                startReadingAction: { openBookDetail(book) },
                openBookDetailsAction: { openBookDetail(book) }
            )
        }
    }
    
    private var continueReadingButton: some View {
        Button(action: continueReading) {
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
        }
        .buttonStyle(PlainButtonStyle())
    }
     
    private var favoriteBooksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Bookmarks.favorite.uppercased())
                .appFont(.h2)
                .foregroundColor(.accentDark)
                .padding(.horizontal)
            
            favoriteBooksList
        }
    }
    
    private var favoriteBooksList: some View {
        VStack(spacing: 16) {
            ForEach(favoriteBooks) { book in
                BookmarkListItem(
                    book: book,
                    isCurrent: false,
                    startReadingAction: { openBookDetail(book) },
                    openBookDetailsAction: { openBookDetail(book) }
                )
            }
        }
    }
    
    private var quotesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Bookmarks.quotes.uppercased())
                .appFont(.h2)
                .foregroundColor(.accentDark)
                .padding(.horizontal)
            
            quotesList
        }
    }
    
    private var quotesList: some View {
        VStack(spacing: 16) {
            ForEach(MockData.quotes) { quote in
                QuoteCard(quote: quote)
                    .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Actions

    private func openBookDetail(_ book: Book) {
        selectedBook = book
    }

    private func continueReading() {
        if let book = currentBook,
           let progress = book.userProgress
        {
            setCurrentBook(book)
            let chapterIndex = min(progress.currentChapter, book.chapters.count - 1)
            selectedChapter = book.chapters[chapterIndex]
        }
    }
}

#Preview {
    BookmarksScreen(
        currentBook: MockData.books[0],
        favoriteBooks: [MockData.books[1], MockData.books[2]],
        setCurrentBook: { _ in },
        toggleFavorite: { _ in }
    )
}
