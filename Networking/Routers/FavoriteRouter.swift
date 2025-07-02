//
//  FavoriteRouter.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

internal import Alamofire

enum FavoriteRouter {
    case getFavorites
    case addToFavorites
    case removeFromFavorites(favoriteId: String)

    var method: HTTPMethod {
        switch self {
        case .getFavorites: return .get
        case .addToFavorites: return .post
        case .removeFromFavorites: return .delete
        }
    }

    var path: String {
        switch self {
        case .getFavorites, .addToFavorites: return "/api/favorites"
        case .removeFromFavorites(let favoriteId): return "/api/favorites/\(favoriteId)"
        }
    }
}
