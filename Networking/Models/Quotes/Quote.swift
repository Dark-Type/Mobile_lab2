//
//  Quote.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

public struct Quote: Codable {
    let id: Int
    let documentId: String
    let text: String
    let createdAt: String
    let updatedAt: String
    let publishedAt: String
    let bookId: Int
}
