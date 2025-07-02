//
//  FavoriteService.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

internal import Alamofire
import Foundation

protocol FavoriteServiceProtocol: Sendable {
    func getFavorites() async throws -> Favorites
    func addToFavorites(_ request: AddFavoriteRequest) async throws -> Favorite
    func removeFromFavorites(favoriteId: String) async throws
}

final class FavoriteService: FavoriteServiceProtocol {
    private let session: Session
    private let baseURL: String

    init(session: Session = .shared, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    func getFavorites() async throws -> Favorites {
        let url = "\(baseURL)\(FavoriteRouter.getFavorites.path)"
        return try await session.request(
            url,
            method: FavoriteRouter.getFavorites.method
        )
        .validate()
        .serializingDecodable(Favorites.self)
        .value
    }

    func addToFavorites(_ request: AddFavoriteRequest) async throws -> Favorite {
        let url = "\(baseURL)\(FavoriteRouter.addToFavorites.path)"
        return try await session.request(
            url,
            method: FavoriteRouter.addToFavorites.method,
            parameters: request,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingDecodable(Favorite.self)
        .value
    }

    func removeFromFavorites(favoriteId: String) async throws {
        let url = "\(baseURL)\(FavoriteRouter.removeFromFavorites(favoriteId: favoriteId).path)"
        _ = try await session.request(
            url,
            method: FavoriteRouter.removeFromFavorites(favoriteId: favoriteId).method
        )
        .validate()
        .serializingData()
        .value
    }
}
