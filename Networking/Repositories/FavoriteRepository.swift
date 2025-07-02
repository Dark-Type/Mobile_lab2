//
//  FavoriteRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

public protocol FavoriteRepositoryProtocol: Sendable {
    func getFavorites() async throws -> Favorites
    func addToFavorites(_ request: AddFavoriteRequest) async throws -> Favorite
    func removeFromFavorites(favoriteId: String) async throws
}

public final class FavoriteRepository: FavoriteRepositoryProtocol {
    private let service: FavoriteServiceProtocol

    public init(service: FavoriteServiceProtocol) {
        self.service = service
    }

    public func getFavorites() async throws -> Favorites {
        try await service.getFavorites()
    }

    public func addToFavorites(_ request: AddFavoriteRequest) async throws -> Favorite {
        try await service.addToFavorites(request)
    }

    public func removeFromFavorites(favoriteId: String) async throws {
        try await service.removeFromFavorites(favoriteId: favoriteId)
    }
}
