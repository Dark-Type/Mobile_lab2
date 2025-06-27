//
//  BookService.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//
import Dependencies
import Foundation

struct BookService: BookServiceProtocol {
    func getCurrentBook() async -> Book? {
        return MockData.books.first
    }

    func setCurrentBook(_ book: Book) async {
        print("🔍 BookService.setCurrentBook - Setting current book: \(book.title)")
    }

    func getFeaturedBooks() async throws -> [Book] {
        try await Task.sleep(nanoseconds: 100_000_000)

        return Array(MockData.books.prefix(3))
    }

    func getPopularBooks() async throws -> [Book] {
        try await Task.sleep(nanoseconds: 100_000_000)

        return MockData.books
    }

    func searchBooks(query: String) async throws -> [Book] {
        try await Task.sleep(nanoseconds: 500_000_000)

        if MockData.isEmptyStateTest {
            return []
        }

        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }

        return MockData.books.filter { book in
            let queryLowercased = query.lowercased()

            return book.title.lowercased().contains(queryLowercased) ||
                   book.author.contains { author in
                       author.name.lowercased().contains(queryLowercased)
                   } ||
                   book.description.lowercased().contains(queryLowercased)
        }
    }

    func getRecentSearches() async -> [String] {

        if MockData.isEmptyStateTest {
            return []
        }

        return ["Android", "Чистый код", "Чистая Архитектура", "Advanced Swift", "iOS"]
    }

    func addRecentSearch(_ query: String) async {
        print("🔍 BookService.addRecentSearch - Adding: '\(query)'")
    }

    func removeRecentSearch(at index: Int) async {
        print("🔍 BookService.removeRecentSearch - Removing search at index: \(index)")
    }

    func getGenres() async -> [String] {
        print("🔍 BookService.getGenres - Loading genres")

        if MockData.isEmptyStateTest {
            return []
        }

        let genres = MockData.genres
        print("🔍 BookService.getGenres - Loaded \(genres.count) genres")
        return genres
    }

    func getAuthors() async -> [Author] {
        print("🔍 BookService.getAuthors - Loading authors")

        if MockData.isEmptyStateTest {
            return []
        }

        return MockData.authors
    }
}
// MARK: - Dependency Registration

extension BookService: DependencyKey {
    static let liveValue: BookServiceProtocol = BookService()
    static let testValue: BookServiceProtocol = BookService()
}

extension DependencyValues {
    var bookService: BookServiceProtocol {
        get { self[BookService.self] }
        set { self[BookService.self] = newValue }
    }
}
