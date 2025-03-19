//
//  GenreCard 2.swift
//  Mobile_lab2
//
//  Created by dark type on 19.03.2025.
//


import SwiftUI

struct AuthorCard: View {
    let author: Author

    var body: some View {
        HStack {
            author.image
                .resizable()
                .frame(width: 64, height: 64)
                .cornerRadius(45)
                .clipped(antialiased: true)
            
            Text(author.name)
                .appFont(.body)
                .foregroundColor(.accentDark)
                .padding(.leading, 16)
                
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.accentLight)
        .cornerRadius(12)
    }
}

#Preview {
    AuthorCard(author: MockData.authors[0])
}
