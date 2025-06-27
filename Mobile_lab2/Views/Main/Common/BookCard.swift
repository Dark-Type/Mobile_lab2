//
//  BookCard.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct BookCard: View {
    // MARK: - Properties

    let book: Book
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void

    // MARK: - Constants

    private enum ViewMetrics {
        static let verticalSpacing: CGFloat = 8
        static let titleDetailsSpacing: CGFloat = 4
        static let cornerRadius: CGFloat = 8
        static let verticalPadding: CGFloat = 4
        static let titleDetailHeightRatio: CGFloat = 0.3
        static let lineHeightMultiple: CGFloat = 1.0
        static let maxAuthorsShown: Int = 2
        static let textOpacity: CGFloat = 0.7
    }

    // MARK: - Computed Properties

    private var shouldShowAdditionalAuthorsLabel: Bool {
        book.author.count > ViewMetrics.maxAuthorsShown
    }

    private var visibleAuthors: [Author] {
        Array(book.author.prefix(ViewMetrics.maxAuthorsShown))
    }

    private var additionalAuthorsCount: Int {
        book.author.count - ViewMetrics.maxAuthorsShown
    }

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            cardContent
        }
        .buttonStyle(.plain)
    }

    // MARK: - Private Views

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: ViewMetrics.verticalSpacing) {
            coverImageView

            detailsView
        }
        .frame(width: width, height: height)
    }

    private var coverImageView: some View {
        book.coverImage
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width)
            .cornerRadius(ViewMetrics.cornerRadius)
            .clipped()
    }

    private var detailsView: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: ViewMetrics.titleDetailsSpacing) {
                titleLabelView(width: geometry.size.width)

                authorsView(width: geometry.size.width)
            }
            .padding(.vertical, ViewMetrics.verticalPadding)
        }
        .frame(height: height * ViewMetrics.titleDetailHeightRatio)
    }

    private func titleLabelView(width: CGFloat) -> some View {
        CustomTextLabel()
            .text(book.title.uppercased())
            .appFont(.header2)
            .foregroundColor(AppColors.accentDark.color)
            .lineHeightMultiple(ViewMetrics.lineHeightMultiple)
            .lineLimit(2)
            .maxWidth(width)
            .truncationMode(.byTruncatingTail)
            .frame(height: calculateTextHeight(font: .header2, lines: 2))
    }

    private func authorsView(width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if !book.author.isEmpty {
                ForEach(visibleAuthors.indices, id: \.self) { index in
                    authorNameView(for: visibleAuthors[index], width: width)
                }

                if shouldShowAdditionalAuthorsLabel {
                    additionalAuthorsView(width: width)
                }
            }
        }
    }

    private func authorNameView(for author: Author, width: CGFloat) -> some View {
        CustomTextLabel()
            .text(author.name)
            .appFont(.bodySmall)
            .foregroundColor(AppColors.accentDark.color)
            .lineHeightMultiple(ViewMetrics.lineHeightMultiple)
            .lineLimit(1)
            .maxWidth(width)
            .truncationMode(.byTruncatingTail)
            .frame(height: calculateTextHeight(font: .bodySmall, lines: 1))
    }

    private func additionalAuthorsView(width: CGFloat) -> some View {
        CustomTextLabel()
            .text("и ещё \(additionalAuthorsCount)")
            .appFont(.bodySmall)
            .foregroundColor(AppColors.accentDark.color.opacity(ViewMetrics.textOpacity))
            .lineHeightMultiple(ViewMetrics.lineHeightMultiple)
            .lineLimit(1)
            .maxWidth(width)
            .truncationMode(.byTruncatingTail)
            .frame(height: calculateTextHeight(font: .bodySmall, lines: 1))
    }

    // MARK: - Helper Methods

    private func calculateTextHeight(font: AppFont, lines: Int) -> CGFloat {
        return font.size * ViewMetrics.lineHeightMultiple * CGFloat(lines)
    }
}

#Preview {
    BookCard(
        book: MockData.books[0],
        width: 150,
        height: 220,
        action: {}
    )
    .padding()
}
