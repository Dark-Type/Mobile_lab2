//
//  FavoritesService.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

import Dependencies
import Foundation

struct FavoritesService: FavoritesServiceProtocol {
    private var favoriteBookIDs: Set<UUID> = []

    func getFavoriteBooks() async -> [Book] {
        let favoriteIDs = [MockData.books[1].id, MockData.books[3].id]
        return MockData.books.filter { favoriteIDs.contains($0.id) }
    }

    func addToFavorites(_ book: Book) async {
        print("Added to favorites: \(book.title)")
    }

    func removeFromFavorites(_ book: Book) async {
        print("Removed from favorites: \(book.title)")
    }

    func isFavorite(_ book: Book) async -> Bool {
        return book.id == MockData.books[1].id || book.id == MockData.books[3].id
    }
}

// MARK: - Dependency Registration

extension FavoritesService: DependencyKey {
    static let liveValue: FavoritesServiceProtocol = FavoritesService()
    static let testValue: FavoritesServiceProtocol = FavoritesService()
}

extension DependencyValues {
    var favoritesService: FavoritesServiceProtocol {
        get { self[FavoritesService.self] }
        set { self[FavoritesService.self] = newValue }
    }
}
