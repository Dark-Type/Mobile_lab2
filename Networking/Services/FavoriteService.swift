//
//  FavoriteService.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import Alamofire
import Foundation

public protocol FavoriteServiceProtocol: Sendable {
    func getFavorites() async throws -> Favorites
    func addToFavorites(_ request: AddFavoriteRequest) async throws -> Favorite
    func removeFromFavorites(favoriteId: String) async throws
}

public final class FavoriteService: FavoriteServiceProtocol {
    private let session: Session
    private let baseURL: String

    public init(session: Session = .default, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    public func getFavorites() async throws -> Favorites {
        let url = "\(baseURL)\(FavoriteRouter.getFavorites.path)"
        return try await session.request(
            url,
            method: FavoriteRouter.getFavorites.method
        )
        .validate()
        .serializingDecodable(Favorites.self)
        .value
    }

    public func addToFavorites(_ request: AddFavoriteRequest) async throws -> Favorite {
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

    public func removeFromFavorites(favoriteId: String) async throws {
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
