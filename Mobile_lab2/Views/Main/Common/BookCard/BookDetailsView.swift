//
//  BookDetailsView.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import SwiftUI

struct BookDetailsView: View {
    let book: Book
    let width: CGFloat
    let height: CGFloat

    private enum ViewMetrics {
        static let titleDetailsSpacing: CGFloat = 4
        static let verticalPadding: CGFloat = 4
        static let titleDetailHeightRatio: CGFloat = 0.3
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: ViewMetrics.titleDetailsSpacing) {
                BookCardTitleLabel(title: book.title, width: geometry.size.width)
                BookAuthorsSection(authors: book.author, width: geometry.size.width)
            }
            .padding(.vertical, ViewMetrics.verticalPadding)
        }
        .frame(height: height * ViewMetrics.titleDetailHeightRatio)
    }
}
