//
//  BookCard.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct BookCard: View {
    let book: Book
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                book.coverImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)

                Text(book.title.uppercased())
                    .appFont(.h2)
                    .foregroundColor(.accentDark)
                    .lineLimit(2)

                VStack(alignment: .leading, spacing: 2) {
                    ForEach(book.author.indices, id: \.self) { index in
                        Text("\(book.author[index])\(index < book.author.count - 1 ? "," : "")")
                            .appFont(.bodySmall)
                            .foregroundColor(.accentDark)
                            .lineLimit(1)
                    }
                }
                .padding(.top, -4)
            }
            .frame(width: width)
        }
        .buttonStyle(PlainButtonStyle())
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
