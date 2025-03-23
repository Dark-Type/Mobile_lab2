//
//  BookmarkListItem.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct BookmarkListItem: View {
    // MARK: - Properties

    let book: Book
    let isCurrent: Bool
    let startReadingAction: () -> Void
    let openBookDetailsAction: () -> Void
    
    // MARK: - Constants

    private enum ViewMetrics {
        static let horizontalSpacing: CGFloat = 16
        static let verticalPadding: CGFloat = 8
        static let coverWidth: CGFloat = 80
        static let itemHeight: CGFloat = 120
        static let cornerRadius: CGFloat = 8
    }
    
    // MARK: - Computed Properties

    private var subtitleText: String {
        isCurrent
            ? book.chapters[book.userProgress.currentChapter].title
            : authorNames
    }
    
    private var authorNames: String {
        book.author.map(\.name).joined(separator: ", ")
    }
    
    // MARK: - Body

    var body: some View {
        Button(action: openBookDetailsAction) {
            contentView
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Private Views

    private var contentView: some View {
        HStack(spacing: ViewMetrics.horizontalSpacing) {
            coverImageView
            
            detailsView
        }
        .padding(.horizontal)
    }
    
    private var coverImageView: some View {
        book.coverImage
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
                width: ViewMetrics.coverWidth,
                height: ViewMetrics.itemHeight
            )
            .cornerRadius(ViewMetrics.cornerRadius)
            .clipped()
    }
    
    private var detailsView: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: ViewMetrics.horizontalSpacing) {
                titleLabelView(width: geometry.size.width)
                
                subtitleLabelView(width: geometry.size.width)
                    
                if isCurrent {
                    progressBarView
                }
                
                Spacer()
            }
            .padding(.vertical, ViewMetrics.verticalPadding)
        }
        .frame(height: ViewMetrics.itemHeight)
    }
    
    private func titleLabelView(width: CGFloat) -> some View {
        CustomTextLabel()
            .text(book.title.uppercased())
            .appFont(.h2)
            .foregroundColor(AppColors.accentDark.color)
            .lineHeightMultiple(1.0)
            .lineLimit(2)
            .maxWidth(width)
            .truncationMode(.byTruncatingTail)
            .frame(height: calculateTextHeight(font: .h2, lineHeightMultiple: 1.0, lines: 2))
    }
    
    private func subtitleLabelView(width: CGFloat) -> some View {
        CustomTextLabel()
            .text(subtitleText)
            .appFont(.body)
            .foregroundColor(AppColors.accentDark.color)
            .lineHeightMultiple(1.0)
            .lineLimit(1)
            .maxWidth(width)
            .truncationMode(.byTruncatingTail)
            .frame(height: calculateTextHeight(font: .body, lineHeightMultiple: 1.0, lines: 1))
    }
    
    private var progressBarView: some View {
        ProgressBar(progress: book.userProgress.overallProgress)
    }
    
    // MARK: - Helper Methods

    private func calculateTextHeight(font: AppFont, lineHeightMultiple: CGFloat, lines: Int) -> CGFloat {
        font.size * CGFloat(lines) * lineHeightMultiple
    }
}

#Preview {
    BookmarkListItem(
        book: MockData.books[3],
        isCurrent: true,
        startReadingAction: {
            print("startReadingAction closure triggered")
        },
        openBookDetailsAction: {
            print("openBookDetailsAction closure triggered")
        }
    )
}
