//
//  BookRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

public protocol BookRepositoryProtocol: Sendable {
    func getBooks(page: Int, pageSize: Int) async throws -> [DomainBook]
    func getBooksById(id: Int) async throws -> [DomainBook]
    func getBooksByName(name: String) async throws -> [DomainBook]
    func getBooksByGenre(genreId: Int) async throws -> [DomainBook]
    func getBooksByAuthor(authorId: Int) async throws -> [DomainBook]
    func getNewBooks(isNew: Bool) async throws -> [DomainBook]
    func getBooksWithAuthors(page: Int, pageSize: Int) async throws -> [DomainBook]
}

public final class BookRepository: BookRepositoryProtocol, @unchecked Sendable {
    private let service: BookServiceProtocol
    private let booksByPageCache = TimedMemoryCache<String, [DomainBook]>(lifetime: 3600)
    private let booksByIdCache = TimedMemoryCache<Int, [DomainBook]>(lifetime: 3600)
    private let booksByNameCache = TimedMemoryCache<String, [DomainBook]>(lifetime: 3600)
    private let booksByGenreCache = TimedMemoryCache<Int, [DomainBook]>(lifetime: 3600)
    private let booksByAuthorCache = TimedMemoryCache<Int, [DomainBook]>(lifetime: 3600)
    private let newBooksCache = TimedMemoryCache<Bool, [DomainBook]>(lifetime: 3600)
    private let booksWithAuthorsCache = TimedMemoryCache<String, [DomainBook]>(lifetime: 3600)

    public init(service: BookServiceProtocol) {
        self.service = service
    }

    public func getBooks(page: Int, pageSize: Int) async throws -> [DomainBook] {
        let key = "\(page)-\(pageSize)"
        if let cached = await booksByPageCache.value(for: key) {
            return cached
        }
        let networkBooks = try await service.getBooks(page: page, pageSize: pageSize)
        let mapped = networkBooks.toDomainBooks()
        await booksByPageCache.set(mapped, for: key)
        return mapped
    }

    public func getBooksById(id: Int) async throws -> [DomainBook] {
        if let cached = await booksByIdCache.value(for: id) {
            return cached
        }
        let networkBooks = try await service.getBooksById(id: id)
        let mapped = networkBooks.toDomainBooks()
        await booksByIdCache.set(mapped, for: id)
        return mapped
    }

    public func getBooksByName(name: String) async throws -> [DomainBook] {
        if let cached = await booksByNameCache.value(for: name) {
            return cached
        }
        let networkBooks = try await service.getBooksByName(name: name)
        let mapped = networkBooks.toDomainBooks()
        await booksByNameCache.set(mapped, for: name)
        return mapped
    }

    public func getBooksByGenre(genreId: Int) async throws -> [DomainBook] {
        if let cached = await booksByGenreCache.value(for: genreId) {
            return cached
        }
        let networkBooks = try await service.getBooksByGenre(genreId: genreId)
        let mapped = networkBooks.toDomainBooks()
        await booksByGenreCache.set(mapped, for: genreId)
        return mapped
    }

    public func getBooksByAuthor(authorId: Int) async throws -> [DomainBook] {
        if let cached = await booksByAuthorCache.value(for: authorId) {
            return cached
        }
        let networkBooks = try await service.getBooksByAuthor(authorId: authorId)
        let mapped = networkBooks.toDomainBooks()
        await booksByAuthorCache.set(mapped, for: authorId)
        return mapped
    }

    public func getNewBooks(isNew: Bool) async throws -> [DomainBook] {
        if let cached = await newBooksCache.value(for: isNew) {
            return cached
        }
        let networkBooks = try await service.getNewBooks(isNew: isNew)
        let mapped = networkBooks.toDomainBooks()
        await newBooksCache.set(mapped, for: isNew)
        return mapped
    }

    public func getBooksWithAuthors(page: Int, pageSize: Int) async throws -> [DomainBook] {
        let key = "\(page)-\(pageSize)"
        if let cached = await booksWithAuthorsCache.value(for: key) {
            return cached
        }
        let networkBooks = try await service.getBooksWithAuthors(page: page, pageSize: pageSize)
        let mapped = networkBooks.toDomainBooks()
        await booksWithAuthorsCache.set(mapped, for: key)
        return mapped
    }
}
