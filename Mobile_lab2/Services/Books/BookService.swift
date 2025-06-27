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
        print("Setting current book: \(book.title)")
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
