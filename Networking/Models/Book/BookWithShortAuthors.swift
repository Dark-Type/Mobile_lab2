//
//  BookWithShortAuthors.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

public struct BookWithShortAuthors: Codable {
    public init(id: Int, documentId: String, title: String, coverURL: String, createdAt: String, updatedAt: String, publishedAt: String, isNew: Bool, illustrationURL: String?, description: String, authors: [ShortAuthor]) {
        self.id = id
        self.documentId = documentId
        self.title = title
        self.coverURL = coverURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.publishedAt = publishedAt
        self.isNew = isNew
        self.illustrationURL = illustrationURL
        self.description = description
        self.authors = authors
    }
    public let id: Int
    public let documentId: String
    public let title: String
    public  let coverURL: String
    public let createdAt: String
    public  let updatedAt: String
    public let publishedAt: String
    public  let isNew: Bool
    public  let illustrationURL: String?
    public  let description: String
    public let authors: [ShortAuthor]
}
