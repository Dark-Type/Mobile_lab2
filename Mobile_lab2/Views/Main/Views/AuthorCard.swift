//
//  GenreCard 2.swift
//  Mobile_lab2
//
//  Created by dark type on 19.03.2025.
//

import SwiftUI

struct AuthorCard: View {
    // MARK: - Properties

    let author: Author

    // MARK: - Constants

    private enum ViewMetrics {
        static let imageSize: CGFloat = 64
        static let imageCornerRadius: CGFloat = 45
        static let textLeadingPadding: CGFloat = 16
        static let cardPadding: CGFloat = 16
        static let cardCornerRadius: CGFloat = 12
    }

    // MARK: - Body

    var body: some View {
        cardContent
    }

    // MARK: - Private Views

    private var cardContent: some View {
        HStack {
            authorImage
            authorName
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(ViewMetrics.cardPadding)
        .background(.accentLight)
        .cornerRadius(ViewMetrics.cardCornerRadius)
    }

    private var authorImage: some View {
        author.image
            .resizable()
            .frame(
                width: ViewMetrics.imageSize,
                height: ViewMetrics.imageSize
            )
            .cornerRadius(ViewMetrics.imageCornerRadius)
            .clipped(antialiased: true)
    }

    private var authorName: some View {
        Text(author.name)
            .appFont(.body)
            .foregroundColor(.accentDark)
            .padding(.leading, ViewMetrics.textLeadingPadding)
    }
}

#Preview {
    AuthorCard(author: MockData.authors[0])
}
