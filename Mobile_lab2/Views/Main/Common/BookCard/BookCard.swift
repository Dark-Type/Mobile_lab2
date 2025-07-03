//
//  BookCard.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct BookCard: View {
    let book: BookUI
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            BookCardContent(book: book, width: width, height: height)
        }
        .buttonStyle(.plain)
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
