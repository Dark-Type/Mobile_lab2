//
//  Book.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

public struct Book: Codable {
    public let id: Int
    public let documentId: String
    public let title: String
    public let coverURL: String
    public let createdAt: String
    public let updatedAt: String
    public let publishedAt: String
    public let isNew: Bool
    public let illustrationURL: String?
    public let description: String
    public let author: [AuthorDTO]
}
