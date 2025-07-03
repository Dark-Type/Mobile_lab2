//
//  FavoriteRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

public protocol FavoriteRepositoryProtocol: Sendable {
    func getFavorites() async throws -> DomainFavorites
    func addToFavorites(_ request: DomainAddFavoriteRequest) async throws -> DomainFavorite
    func removeFromFavorites(favoriteId: String) async throws
}

public final class FavoriteRepository: FavoriteRepositoryProtocol {
    private let service: FavoriteServiceProtocol

    public init(service: FavoriteServiceProtocol) {
        self.service = service
    }

    public func getFavorites() async throws -> DomainFavorites {
        let networkData = try await service.getFavorites()
        return networkData.toDomainFavorites()
    }

    public func addToFavorites(_ request: DomainAddFavoriteRequest) async throws -> DomainFavorite {
        let networkRequest = request.toAddFavoriteRequest()
        let networkData = try await service.addToFavorites(networkRequest)
        return networkData.toDomainFavorite()
    }

    public func removeFromFavorites(favoriteId: String) async throws {
        try await service.removeFromFavorites(favoriteId: favoriteId)
    }
}
