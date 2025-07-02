//
//  BookService.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//
import Dependencies
import Foundation

//struct BookService: BookServiceProtocol {
//    // MARK: - Currently Reading Books
//
//    func getCurrentBooks() async -> [Book] {
//        return Array(MockData.books.prefix(2))
//    }
//
//    func addToCurrentBooks(_ book: Book) async {
//        print("🔍 BookService.addToCurrentBooks - Adding: \(book.title)")
//    }
//
//    func removeFromCurrentBooks(_ book: Book) async {
//        print("🔍 BookService.removeFromCurrentBooks - Removing: \(book.title)")
//    }
//
//    func moveBookToTop(_ book: Book) async {
//        print("🔍 BookService.moveBookToTop - Moving to top: \(book.title)")
//    }
//
//    // MARK: - Featured and Popular Books
//
//    func getFeaturedBooks() async throws -> [Book] {
//        try await Task.sleep(nanoseconds: 100_000_000)
//
//        return Array(MockData.books.prefix(3))
//    }
//
//    func getPopularBooks() async throws -> [Book] {
//        try await Task.sleep(nanoseconds: 100_000_000)
//
//        return MockData.books
//    }
//
//    // MARK: - Search functionality
//
//    func searchBooks(query: String) async throws -> [Book] {
//        try await Task.sleep(nanoseconds: 500_000_000)
//
//        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
//            return []
//        }
//
//        return MockData.books.filter { book in
//            let queryLowercased = query.lowercased()
//            return book.title.lowercased().contains(queryLowercased) ||
//                book.author.contains { $0.name.lowercased().contains(queryLowercased) } ||
//                book.description.lowercased().contains(queryLowercased)
//        }
//
//    }
//
//    func getRecentSearches() async -> [String] {
//        if MockData.isEmptyStateTest {
//            return []
//        }
//        return ["Android", "Чистый код", "Чистая Архитектура", "Advanced Swift", "iOS"]
//    }
//
//    func addRecentSearch(_ query: String) async {
//        print("🔍 BookService.addRecentSearch - Adding: '\(query)'")
//    }
//
//    func removeRecentSearch(at index: Int) async {
//        print("🔍 BookService.removeRecentSearch - Removing at index: \(index)")
//    }
//
//    func getGenres() async -> [String] {
//        if MockData.isEmptyStateTest {
//            return []
//        }
//        return MockData.genres
//    }
//
//    func getAuthors() async -> [Author] {
//        if MockData.isEmptyStateTest {
//            return []
//        }
//        return MockData.authors
//    }
//}
//
//// MARK: - Dependency Registration
//
//extension BookService: DependencyKey {
//    static let liveValue: BookServiceProtocol = BookService()
//    static let testValue: BookServiceProtocol = BookService()
//}
//
//extension DependencyValues {
//    var bookService: BookServiceProtocol {
//        get { self[BookService.self] }
//        set { self[BookService.self] = newValue }
//    }
//}
