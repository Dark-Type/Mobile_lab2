//
//  DomainFavorites.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

public struct DomainFavorites: Codable {
    public let favorites: [DomainFavorite]

    public init(favorites: [DomainFavorite]) {
        self.favorites = favorites
    }
}

public struct DomainFavorite: Identifiable, Codable {
    public let id: String
    public let bookId: String
    public let createdAt: String

    public init(id: String, bookId: String, createdAt: String) {
        self.id = id
        self.bookId = bookId
        self.createdAt = createdAt
    }
}

public struct DomainAddFavoriteRequest: Codable {
    public let bookId: String

    public init(bookId: String) {
        self.bookId = bookId
    }
}
