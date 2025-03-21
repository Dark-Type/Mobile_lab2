//
//  QuoteCard 2.swift
//  Mobile_lab2
//
//  Created by dark type on 19.03.2025.
//

import SwiftUI

struct GenreCard: View {
    let genre: String

    var body: some View {
        Text(genre)
            .appFont(.body)
            .foregroundColor(.accentDark)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .frame(height: 60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.accentLight)
            .cornerRadius(12)
    }
}

#Preview {
    GenreCard(genre: "Классика")
}
