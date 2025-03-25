//
//  BookmarksView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct BookmarksScreen: View {
    // MARK: - State

    @State private var selectedBook: Book?
    @State private var selectedChapter: Chapter? = nil
    
    // MARK: - Properties

    let currentBook: Book?
    let favoriteBooks: [Book]
    let setCurrentBook: (Book) -> Void
    let toggleFavorite: (Book) -> Void
    let quotes = MockData.quotes

    static var isTestMode: Bool {
        ProcessInfo.processInfo.arguments.contains("-UITestMode")
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                titleView
                   
                if BookmarksScreen.isTestMode {
                    if let book = MockData.testCurrentBook {
                        currentlyReadingSection(book: book)
                    }
                    if !MockData.isEmptyStateTest {
                        favoriteBooksSection
                    } else {
                        emptyFavoriteBooksView
                    }
                } else {
                    if let book = currentBook {
                        currentlyReadingSection(book: book)
                    }
                    if !favoriteBooks.isEmpty {
                        favoriteBooksSection
                    } else {
                        emptyFavoriteBooksView
                    }
                }
                               
                if !quotes.isEmpty {
                    quotesSection
                                    
                } else {
                    emptyQuotesView
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
            .accessibilityIdentifier(AccessibilityIdentifiers.bookmarksTitle.rawValue)
    }
     
    private func currentlyReadingSection(book: Book) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center) {
                Text(L10n.Bookmarks.current.uppercased())
                    .appFont(.h2)
                    .foregroundColor(.accentDark)
                    .accessibilityIdentifier(AccessibilityIdentifiers.currentReadingSectionTitle.rawValue)
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
            .accessibilityIdentifier(AccessibilityIdentifiers.currentReadingBookItem.rawValue)
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
        .accessibilityIdentifier(AccessibilityIdentifiers.continueReadingButton.rawValue)
    }
     
    private var favoriteBooksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Bookmarks.favorite.uppercased())
                .appFont(.h2)
                .foregroundColor(.accentDark)
                .padding(.horizontal)
                .accessibilityIdentifier(AccessibilityIdentifiers.favoriteBooksSectionTitle.rawValue)
            
            favoriteBooksList
        }
    }
    
    private var favoriteBooksList: some View {
        VStack(spacing: 16) {
            ForEach(BookmarksScreen.isTestMode ? MockData.testFavoriteBooks! : favoriteBooks) { book in
                BookmarkListItem(
                    book: book,
                    isCurrent: false,
                    startReadingAction: { openBookDetail(book) },
                    openBookDetailsAction: { openBookDetail(book) }
                )
                .accessibilityIdentifier("\(AccessibilityIdentifiers.favoriteBookItem.rawValue)_\(book.id)")
            }
        }
    }
    
    private var quotesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Bookmarks.quotes.uppercased())
                .appFont(.h2)
                .foregroundColor(.accentDark)
                .padding(.horizontal)
                .accessibilityIdentifier(AccessibilityIdentifiers.quotesSectionTitle.rawValue)
            
            quotesList
        }
    }
    
    private var quotesList: some View {
        VStack(spacing: 16) {
            ForEach(MockData.quotes) { quote in
                QuoteCard(quote: quote)
                    .padding(.horizontal)
                    .accessibilityIdentifier("\(AccessibilityIdentifiers.quoteItem.rawValue)_\(quote.id)")
            }
        }
    }

    private var emptyFavoriteBooksView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Bookmarks.favorite.uppercased())
                .appFont(.h2)
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
        
    private var emptyQuotesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Bookmarks.quotes.uppercased())
                .appFont(.h2)
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
        
    private func emptyStateCard(message: String, description: String) -> some View {
        VStack(spacing: 8) {
            Text(message)
                .appFont(.body)
                .foregroundColor(.accentDark)
                .multilineTextAlignment(.center)
                
            Text(description)
                .appFont(.h2)
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
        
    // MARK: - Actions

    private func openBookDetail(_ book: Book) {
        selectedBook = BookmarksScreen.isTestMode ? MockData.testCurrentBook : book
    }

    private func continueReading() {
        if let book = currentBook {
            let progress = book.userProgress
        
            setCurrentBook(book)
            let chapterIndex = min(progress.currentChapter, book.chapters.count - 1)
            selectedChapter = book.chapters[chapterIndex]
        }
    }
}

#Preview {
    BookmarksScreen(
        currentBook: MockData.books[0],
        favoriteBooks: [MockData.books[1], MockData.books[3]],
        setCurrentBook: { _ in },
        toggleFavorite: { _ in }
    )
}
