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
                        if book.author.count > 0 {
                            ForEach(0..<min(2, book.author.count), id: \.self) { index in
                                Text(book.author[index].name)
                                    .appFont(.bodySmall)
                                    .foregroundColor(.accentDark)
                                    .lineLimit(1)
                            }
                            
                            if book.author.count > 2 {
                                Text("+ \(book.author.count - 2) more")
                                    .appFont(.footnote)
                                    .foregroundColor(.accentDark.opacity(0.7))
                            }
                        }
                    }
                    .padding(.top, -4)
                }
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
