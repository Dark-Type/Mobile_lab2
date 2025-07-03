//
//  Quote.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

public struct NetworkQuote: Codable {
    public let id: Int
    public let documentId: String
    public  let text: String
    public let createdAt: String
    public let updatedAt: String
    public let publishedAt: String
    public let bookId: Int
}
