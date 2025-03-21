//
//  BookmarkListItem.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct BookmarkListItem: View {
    let book: Book
    let isCurrent: Bool
    let startReadingAction: () -> Void
    let openBookDetailsAction: () -> Void
    
    var body: some View {
        Button(action: openBookDetailsAction) {
            HStack(spacing: 16) {
                book.coverImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 120)
                    .cornerRadius(8)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(book.title)
                        .appFont(.h1)
                        .foregroundColor(.accentDark)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(isCurrent ? book.chapters[book.userProgress?.currentChapter ?? 0].title : book.author.map { $0.name }.joined(separator: ", "))
                        .appFont(.body)
                        .foregroundColor(.accentDark)
                    if isCurrent, let progress = book.userProgress {
                        ProgressBar(progress: progress.overallProgress)
                    }
                }
                
                .padding(.vertical, 8)
            }
            
            .padding(.horizontal)
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    BookmarkListItem(
        book: MockData.books[0],
        isCurrent: true,
        startReadingAction: {
            print("startReadingAction closure triggered")
        },
        openBookDetailsAction: {
            print("openBookDetailsAction closure triggered")
        }
    )
}
