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
