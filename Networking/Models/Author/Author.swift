//
//  Author.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

public struct AuthorDTO: Codable {
    public init(id: Int, documentId: String, name: String, createdAt: String, updatedAt: String, publishedAt: String) {
        self.id = id
        self.documentId = documentId
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.publishedAt = publishedAt
    }

    public let id: Int
    public let documentId: String
    public let name: String
    public let createdAt: String
    public let updatedAt: String
    public let publishedAt: String
}
