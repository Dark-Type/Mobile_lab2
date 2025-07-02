//
//  BookCardContent.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import SwiftUI

struct BookCardContent: View {
    let book: Book
    let width: CGFloat
    let height: CGFloat

    private enum ViewMetrics {
        static let verticalSpacing: CGFloat = 8
        static let titleDetailsSpacing: CGFloat = 4
        static let cornerRadius: CGFloat = 8
        static let verticalPadding: CGFloat = 4
        static let titleDetailHeightRatio: CGFloat = 0.3
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ViewMetrics.verticalSpacing) {
            BookCoverImage(image: book.coverImage, width: width)
            BookDetailsView(book: book, width: width, height: height)
        }
        .frame(width: width, height: height)
    }
}
