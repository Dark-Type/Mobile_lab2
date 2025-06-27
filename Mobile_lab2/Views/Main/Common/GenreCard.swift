//
//  QuoteCard 2.swift
//  Mobile_lab2
//
//  Created by dark type on 19.03.2025.
//

import SwiftUI

struct GenreCard: View {
    // MARK: - Properties

    let genre: String

    // MARK: - Constants

    private enum ViewMetrics {
        static let verticalPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 20
        static let cardHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 12
        static let lineLimit: Int = 2
    }

    var body: some View {
        cardContent
    }

    private var cardContent: some View {
        Text(genre)
            .appFont(.body)
            .foregroundColor(.accentDark)
            .lineLimit(ViewMetrics.lineLimit)
            .multilineTextAlignment(.leading)
            .padding(.vertical, ViewMetrics.verticalPadding)
            .padding(.horizontal, ViewMetrics.horizontalPadding)
            .frame(height: ViewMetrics.cardHeight)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.accentLight)
            .cornerRadius(ViewMetrics.cornerRadius)
    }
}

#Preview {
    GenreCard(genre: "Классика")
}
