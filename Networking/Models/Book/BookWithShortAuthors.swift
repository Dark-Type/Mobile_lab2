//
//  BookWithShortAuthors.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

public struct BookWithShortAuthors: Codable {
    let id: Int
    let documentId: String
    let title: String
    let coverURL: String
    let createdAt: String
    let updatedAt: String
    let publishedAt: String
    let isNew: Bool
    let illustrationURL: String?
    let description: String
    let authors: [ShortAuthor]
}
