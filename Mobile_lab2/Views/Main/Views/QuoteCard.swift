//
//  QuoteCard.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct QuoteCard: View {
    let quote: Quote

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(quote.content)
                .appFont(.quote).italic(true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(AppColors.black.color)
                .lineSpacing(6)
                .padding(.bottom, 4)

            Text(quote.bookTitle + " • " + quote.author.map { $0.name }.joined(separator: ", "))
                .appFont(.bodySmall)
                .foregroundColor(.accentDark)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.accentLight)
        .cornerRadius(12)
    }
}

#Preview {
    QuoteCard(quote: MockData.quotes[0])
}
