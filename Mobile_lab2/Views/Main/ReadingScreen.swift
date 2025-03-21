//
//  PlayerView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct ReadingScreen: View {
    // MARK: - Properties

    let book: Book
    let setCurrentBook: (Book) -> Void
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showChapters: Bool = false
    @State private var selectedChapter: Chapter? = nil
    
    // MARK: - View

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                book.posterImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: AppColors.background.color
                                    .opacity(0), location: 0),
                                .init(color: AppColors.background.color.opacity(1), location: 1)
                            ]),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(12)
                    
                HStack(alignment: .center, spacing: 10) {
                    Button {
                        if let firstChapter = book.chapters.first {
                            openChapter(firstChapter)
                        }
                    } label: {
                        HStack {
                            AppIcons.play.image
                                .renderingMode(.template)
                            Text(L10n.Book.read)
                        }
                        .appFont(.body).bold(true)
                        .foregroundColor(AppColors.white.color)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(.accentDark)
                        .cornerRadius(10)
                    }
                    
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
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(isFavorite ? .secondaryRed : .accentLight)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.top, -45)
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(book.title.uppercased())
                        .appFont(.h1)
                    
                    Text(book.author.map { $0.name }.joined(separator: ", "))
                        .appFont(.body)
                    
                    Text(book.description)
                        .appFont(.body)
                        .padding(.top, 8)
                }
                .foregroundStyle(.accentDark)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.Book.readBook.uppercased())
                        .appFont(.h2)
                        .foregroundStyle(.accentDark)
                    
                    ProgressBar(
                        progress: book.userProgress?.overallProgress ?? 0.0
                    )
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(L10n.Book.contents.uppercased())
                        .appFont(.h2)
                        .foregroundStyle(.accentDark)
                    
                    ForEach(book.chapters) { chapter in
                        ChapterListItem(chapter: chapter) {
                            openChapter(chapter)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }
            .padding(.bottom, 32)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        AppIcons.arrowLeft.image
                        Text(L10n.Book.goBack)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(AppColors.white.color)
                    }
                }
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
