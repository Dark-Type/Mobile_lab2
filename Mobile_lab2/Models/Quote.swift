//
//  Quote.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import Foundation

struct Quote: Identifiable {
    let id: UUID
    let content: String
    let bookId: UUID
    let bookTitle: String
    let author: [Author]
    let dateAdded: Date

    init(id: UUID = UUID(), content: String, bookId: UUID, bookTitle: String, author: [Author], dateAdded: Date = Date()) {
        self.id = id
        self.content = content
        self.bookId = bookId
        self.bookTitle = bookTitle
        self.author = author

        self.dateAdded = dateAdded
    }
}
