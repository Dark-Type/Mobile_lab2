//
//  ReferenceDataRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

import Foundation

public protocol ReferenceDataRepositoryProtocol: Sendable {
    func getAuthors() async throws -> DomainAuthors
    func getGenres() async throws -> DomainGenres
}

public final class ReferenceDataRepository: ReferenceDataRepositoryProtocol, @unchecked Sendable {
    private let service: ReferenceDataServiceProtocol
    private let authorsCache = TimedMemoryCache<String, DomainAuthors>(lifetime: .infinity)
    private let genresCache = TimedMemoryCache<String, DomainGenres>(lifetime: .infinity)

    public init(service: ReferenceDataServiceProtocol) {
        self.service = service
    }

    public func getAuthors() async throws -> DomainAuthors {
        if let cached = await authorsCache.value(for: "authors") {
            return cached
        }
        let networkData = try await service.getAuthors()
        let mapped = networkData.toDomainAuthors()
        await authorsCache.set(mapped, for: "authors")
        return mapped
    }

    public func getGenres() async throws -> DomainGenres {
        if let cached = await genresCache.value(for: "genres") {
            return cached
        }
        let networkData = try await service.getGenres()
        let mapped = networkData.toDomainGenres()
        await genresCache.set(mapped, for: "genres")
        return mapped
    }
}
