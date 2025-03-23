//
//  QuoteCard.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

import SwiftUI

struct QuoteCard: View {
    // MARK: - Constants

    private enum ViewMetrics {
        static let spacing: CGFloat = 12
        static let padding: CGFloat = 16
        static let cornerRadius: CGFloat = 12
        static let lineSpacing: CGFloat = 6
        static let quoteBottomPadding: CGFloat = 4
    }

    // MARK: - Properties

    let quote: Quote

    var body: some View {
        VStack(alignment: .leading, spacing: ViewMetrics.spacing) {
            Text(quote.content)
                .appFont(.quote).italic(true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(AppColors.black.color)
                .lineSpacing(ViewMetrics.lineSpacing)
                .padding(.bottom, ViewMetrics.quoteBottomPadding)

            Text(quote.bookTitle + " • " + quote.author.map { $0.name }.joined(separator: ", "))
                .appFont(.bodySmall)
                .foregroundColor(.accentDark)
        }
        .padding(ViewMetrics.padding)
        .frame(maxWidth: .infinity)
        .background(.accentLight)
        .cornerRadius(ViewMetrics.cornerRadius)
    }
}

#Preview {
    QuoteCard(quote: MockData.quotes[0])
}
