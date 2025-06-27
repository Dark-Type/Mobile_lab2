//
//  FavoritesServiceProtocol.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

protocol FavoritesServiceProtocol: Sendable {
    func getFavoriteBooks() async -> [Book]
    func addToFavorites(_ book: Book) async
    func removeFromFavorites(_ book: Book) async
    func isFavorite(_ book: Book) async -> Bool

    func getQuotes() async -> [Quote]
    func addQuote(_ quote: Quote) async
    func removeQuote(_ quote: Quote) async
    func updateQuote(_ quote: Quote) async
}
