//
//  ReferenceDataRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

import Foundation

protocol ReferenceDataRepositoryProtocol: Sendable {
    func getAuthors() async throws -> Authors
    func getGenres() async throws -> Genres
}

final class ReferenceDataRepository: ReferenceDataRepositoryProtocol, Sendable {
    private let service: ReferenceDataServiceProtocol
    private let authorsCache = TimedMemoryCache<String, Authors>(lifetime: .infinity)
    private let genresCache = TimedMemoryCache<String, Genres>(lifetime: .infinity)

    init(service: ReferenceDataServiceProtocol) {
        self.service = service
    }

    func getAuthors() async throws -> Authors {
        if let cached = await authorsCache.value(for: "authors") {
            return cached
        }
        let loaded = try await service.getAuthors()
        await authorsCache.set(loaded, for: "authors")
        return loaded
    }

    func getGenres() async throws -> Genres {
        if let cached = await genresCache.value(for: "genres") {
            return cached
        }
        let loaded = try await service.getGenres()
        await genresCache.set(loaded, for: "genres")
        return loaded
    }
}
