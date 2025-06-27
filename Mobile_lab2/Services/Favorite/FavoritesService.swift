//
//  FavoritesService.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

import Dependencies
import Foundation

struct FavoritesService: FavoritesServiceProtocol {

    // MARK: - Favorite Books

    func getFavoriteBooks() async -> [Book] {

        if MockData.isEmptyStateTest {
            return []
        }

        return [MockData.books[1], MockData.books[3]]
    }

    func addToFavorites(_ book: Book) async {
        print("🔍 FavoritesService.addToFavorites - Added: \(book.title)")
    }

    func removeFromFavorites(_ book: Book) async {
        print("🔍 FavoritesService.removeFromFavorites - Removed: \(book.title)")
    }

    func isFavorite(_ book: Book) async -> Bool {
        let favoriteBooks = await getFavoriteBooks()
        return favoriteBooks.contains { $0.id == book.id }
    }

    // MARK: - Quotes

    func getQuotes() async -> [Quote] {

        if MockData.isEmptyStateTest {
            return []
        }

        return MockData.quotes
    }

    func addQuote(_ quote: Quote) async {
        print("🔍 FavoritesService.addQuote - Added quote from: \(quote.bookTitle)")
    }

    func removeQuote(_ quote: Quote) async {
        print("🔍 FavoritesService.removeQuote - Removed quote: \(quote.id)")
    }

    func updateQuote(_ quote: Quote) async {
        print("🔍 FavoritesService.updateQuote - Updated quote: \(quote.id)")
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
