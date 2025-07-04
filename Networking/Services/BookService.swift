//
//  BookService.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import Alamofire
import Foundation

public protocol BookServiceProtocol: Sendable {
    func getBooks(page: Int, pageSize: Int) async throws -> Books
    func getBooksById(id: Int) async throws -> Books
    func getBooksByName(name: String) async throws -> Books
    func getBooksByGenre(genreId: Int) async throws -> Books
    func getBooksByAuthor(authorId: Int) async throws -> Books
    func getNewBooks(isNew: Bool) async throws -> Books
    func getBooksWithAuthors(page: Int, pageSize: Int) async throws -> [BookWithShortAuthors]
}

public final class BookService: BookServiceProtocol {
    private let session: Session
    private let baseURL: String

    public init(session: Session = .default, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    public func getBooks(page: Int, pageSize: Int) async throws -> Books {
        let router = BookRouter.getBooks(page: page, pageSize: pageSize)
        let url = "\(baseURL)\(router.path)"
        return try await session.request(
            url,
            method: router.method,
            parameters: router.query,
            encoding: URLEncoding.default
        )
        .validate()
        .serializingDecodable(Books.self)
        .value
    }

    public func getBooksById(id: Int) async throws -> Books {
        let router = BookRouter.getBooksById(id: id)
        let url = "\(baseURL)\(router.path)"
        return try await session.request(
            url,
            method: router.method,
            parameters: router.query,
            encoding: URLEncoding.default
        )
        .validate()
        .serializingDecodable(Books.self)
        .value
    }

    public func getBooksByName(name: String) async throws -> Books {
        let router = BookRouter.getBooksByName(name: name)
        let url = "\(baseURL)\(router.path)"
        return try await session.request(
            url,
            method: router.method,
            parameters: router.query,
            encoding: URLEncoding.default
        )
        .validate()
        .serializingDecodable(Books.self)
        .value
    }

    public func getBooksByGenre(genreId: Int) async throws -> Books {
        let router = BookRouter.getBooksByGenre(genreId: genreId)
        let url = "\(baseURL)\(router.path)"
        return try await session.request(
            url,
            method: router.method,
            parameters: router.query,
            encoding: URLEncoding.default
        )
        .validate()
        .serializingDecodable(Books.self)
        .value
    }

    public func getBooksByAuthor(authorId: Int) async throws -> Books {
        let router = BookRouter.getBooksByAuthor(authorId: authorId)
        let url = "\(baseURL)\(router.path)"
        return try await session.request(
            url,
            method: router.method,
            parameters: router.query,
            encoding: URLEncoding.default
        )
        .validate()
        .serializingDecodable(Books.self)
        .value
    }

    public func getNewBooks(isNew: Bool) async throws -> Books {
        let router = BookRouter.getNewBooks(isNew: isNew)
        let url = "\(baseURL)\(router.path)"
        return try await session.request(
            url,
            method: router.method,
            parameters: router.query,
            encoding: URLEncoding.default
        )
        .validate()
        .serializingDecodable(Books.self)
        .value
    }

    public func getBooksWithAuthors(page: Int, pageSize: Int) async throws -> [BookWithShortAuthors] {
        let router = BookRouter.getBooksWithAuthors(page: page, pageSize: pageSize)
        let url = "\(baseURL)\(router.path)"
        return try await session.request(
            url,
            method: router.method,
            parameters: router.query,
            encoding: URLEncoding.default
        )
        .validate()
        .serializingDecodable([BookWithShortAuthors].self)
        .value
    }
}
