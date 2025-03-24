//
//  PlayerView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

import SwiftUI

struct ReadingScreen: View {
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
    
    // MARK: - Properties
    
    let book: Book
    let setCurrentBook: (Book) -> Void
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var showChapters: Bool = false
    @State private var selectedChapter: Chapter? = nil
    
    // MARK: - Body
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: ViewMetrics.spacing) {
                posterView
                actionButtons
                bookInfoSection
                if book.userProgress.currentChapter != 0 {
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
        .toolbarBackground(.hidden, for: .navigationBar)
        .ignoresSafeArea(.all)
        .fullScreenCover(item: $selectedChapter) { chapter in
            NavigationStack {
                ChapterReadingView(book: book, setCurrentBook: setCurrentBook, chapter: chapter)
                    .toolbarBackground(Color.clear, for: .navigationBar)
            }
        }
    }
    
    // MARK: - View Components
    
    private var posterView: some View {
        book.posterImage
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
    }
    
    private var actionButtons: some View {
        HStack(alignment: .center, spacing: ViewMetrics.buttonSpacing) {
            readButton
            favoriteButton
        }
        .padding(.horizontal, ViewMetrics.horizontalPadding)
        .padding(.top, ViewMetrics.topButtonsPaddingTop)
        .frame(maxWidth: .infinity)
    }
    
    private var readButton: some View {
        Button {
            let chapter = book.chapters[book.userProgress.currentChapter]
            openChapter(chapter)
        } label: {
            HStack {
                AppIcons.play.image
                    .renderingMode(.template)
                Text(L10n.Book.read)
            }
            .appFont(.body).bold(true)
            .foregroundColor(AppColors.white.color)
            .padding(.horizontal, ViewMetrics.buttonHorizontalPadding)
            .padding(.vertical, ViewMetrics.buttonVerticalPadding)
            .frame(maxWidth: .infinity)
            .background(.accentDark)
            .cornerRadius(ViewMetrics.buttonCornerRadius)
        }
    }
    
    private var favoriteButton: some View {
        Button {
            toggleFavorite()
        } label: {
            HStack {
                AppIcons.bookmarks.image
                    .renderingMode(.template)
                Text(isFavorite ? "Убрать из избранного" : L10n.Book.favorites)
            }
            .appFont(.body).bold()
            .foregroundColor(.accentDark)
            .padding(.horizontal, ViewMetrics.buttonHorizontalPadding)
            .padding(.vertical, ViewMetrics.buttonVerticalPadding)
            .frame(maxWidth: .infinity)
            .background(isFavorite ? .secondaryRed : .accentLight)
            .cornerRadius(ViewMetrics.buttonCornerRadius)
        }
    }
    
    private var bookInfoSection: some View {
        VStack(alignment: .leading, spacing: ViewMetrics.contentSpacing) {
            Text(book.title.uppercased())
                .appFont(.h1)
            
            Text(book.author.map { $0.name }.joined(separator: ", "))
                .appFont(.body)
            
            Text(book.description)
                .appFont(.body)
                .padding(.top, ViewMetrics.descriptionPaddingTop)
        }
        .foregroundStyle(.accentDark)
        .padding(.horizontal, ViewMetrics.horizontalPadding)
    }
    
    private var readingProgressSection: some View {
        VStack(alignment: .leading, spacing: ViewMetrics.contentSpacing) {
            Text(L10n.Book.readBook.uppercased())
                .appFont(.h2)
                .foregroundStyle(.accentDark)
            
            ProgressBar(progress: book.userProgress.overallProgress)
        }
        .padding(.horizontal, ViewMetrics.horizontalPadding)
        .padding(.top, ViewMetrics.progressBarPaddingTop)
    }
    
    private var chaptersSection: some View {
        VStack(alignment: .leading, spacing: ViewMetrics.headerSpacing) {
            Text(L10n.Book.contents.uppercased())
                .appFont(.h2)
                .foregroundStyle(.accentDark)
            
            ForEach(book.chapters) { chapter in
                ChapterListItem(chapter: chapter, action: { openChapter(chapter) }, showStatusIcon: true)
            }
        }
        .padding(.horizontal, ViewMetrics.horizontalPadding)
        .padding(.top, ViewMetrics.chaptersPaddingTop)
    }
    
    private var backButton: some View {
        Button(action: { dismiss() }) {
            HStack {
                AppIcons.arrowLeft.image
                Text(L10n.Book.goBack)
                    .font(.system(size: ViewMetrics.backButtonFontSize, weight: .medium))
                    .foregroundStyle(AppColors.white.color)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func openChapter(_ chapter: Chapter) {
        setCurrentBook(book)
        selectedChapter = chapter
    }
}

#Preview {
    NavigationStack {
        ReadingScreen(
            book: MockData.books[0],
            setCurrentBook: { _ in },
            isFavorite: false,
            toggleFavorite: {}
        )
    }
}
