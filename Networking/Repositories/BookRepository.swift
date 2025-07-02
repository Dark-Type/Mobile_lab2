//
//  BookRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

public protocol BookRepositoryProtocol: Sendable {
    func getBooks(page: Int, pageSize: Int) async throws -> Books
    func getBooksById(id: Int) async throws -> Books
    func getBooksByName(name: String) async throws -> Books
    func getBooksByGenre(genreId: Int) async throws -> Books
    func getBooksByAuthor(authorId: Int) async throws -> Books
    func getNewBooks(isNew: Bool) async throws -> Books
    func getBooksWithAuthors(page: Int, pageSize: Int) async throws -> [BookWithShortAuthors]
}

public final class BookRepository: BookRepositoryProtocol, @unchecked Sendable {
    private let service: BookServiceProtocol
    private let booksByPageCache = TimedMemoryCache<String, Books>(lifetime: 3600)
    private let booksByIdCache = TimedMemoryCache<Int, Books>(lifetime: 3600)
    private let booksByNameCache = TimedMemoryCache<String, Books>(lifetime: 3600)
    private let booksByGenreCache = TimedMemoryCache<Int, Books>(lifetime: 3600)
    private let booksByAuthorCache = TimedMemoryCache<Int, Books>(lifetime: 3600)
    private let newBooksCache = TimedMemoryCache<Bool, Books>(lifetime: 3600)
    private let booksWithAuthorsCache = TimedMemoryCache<String, [BookWithShortAuthors]>(lifetime: 3600)

    public init(service: BookServiceProtocol) {
        self.service = service
    }

    public func getBooks(page: Int, pageSize: Int) async throws -> Books {
        let key = "\(page)-\(pageSize)"
        if let cached = await booksByPageCache.value(for: key) {
            return cached
        }
        let loaded = try await service.getBooks(page: page, pageSize: pageSize)
        await booksByPageCache.set(loaded, for: key)
        return loaded
    }

    public func getBooksById(id: Int) async throws -> Books {
        if let cached = await booksByIdCache.value(for: id) {
            return cached
        }
        let loaded = try await service.getBooksById(id: id)
        await booksByIdCache.set(loaded, for: id)
        return loaded
    }

    public func getBooksByName(name: String) async throws -> Books {
        if let cached = await booksByNameCache.value(for: name) {
            return cached
        }
        let loaded = try await service.getBooksByName(name: name)
        await booksByNameCache.set(loaded, for: name)
        return loaded
    }

    public func getBooksByGenre(genreId: Int) async throws -> Books {
        if let cached = await booksByGenreCache.value(for: genreId) {
            return cached
        }
        let loaded = try await service.getBooksByGenre(genreId: genreId)
        await booksByGenreCache.set(loaded, for: genreId)
        return loaded
    }

    public func getBooksByAuthor(authorId: Int) async throws -> Books {
        if let cached = await booksByAuthorCache.value(for: authorId) {
            return cached
        }
        let loaded = try await service.getBooksByAuthor(authorId: authorId)
        await booksByAuthorCache.set(loaded, for: authorId)
        return loaded
    }

    public func getNewBooks(isNew: Bool) async throws -> Books {
        if let cached = await newBooksCache.value(for: isNew) {
            return cached
        }
        let loaded = try await service.getNewBooks(isNew: isNew)
        await newBooksCache.set(loaded, for: isNew)
        return loaded
    }

    public func getBooksWithAuthors(page: Int, pageSize: Int) async throws -> [BookWithShortAuthors] {
        let key = "\(page)-\(pageSize)"
        if let cached = await booksWithAuthorsCache.value(for: key) {
            return cached
        }
        let loaded = try await service.getBooksWithAuthors(page: page, pageSize: pageSize)
        await booksWithAuthorsCache.set(loaded, for: key)
        return loaded
    }
}
