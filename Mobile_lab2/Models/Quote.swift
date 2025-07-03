//
//  Quote.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import Foundation

struct Quote: Identifiable, Equatable {
    let id: String
    let content: String
    let bookId: String
    let bookTitle: String
    let author: [Author]
    let dateAdded: Date

    init(id: String = UUID().uuidString, content: String, bookId: String, bookTitle: String, author: [Author], dateAdded: Date = Date()) {
        self.id = id
        self.content = content
        self.bookId = bookId
        self.bookTitle = bookTitle
        self.author = author

        self.dateAdded = dateAdded
    }
}
