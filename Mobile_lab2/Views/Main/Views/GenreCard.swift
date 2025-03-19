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
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.accentDark)
            .padding(32)
            .background(.accentLight)
            .cornerRadius(12)
    }
}

#Preview {
    GenreCard(genre: "Классика")
}
