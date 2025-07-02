//
//  FavoriteRouter.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

enum FavoriteRouter {
    case getFavorites
    case addToFavorites
    case removeFromFavorites(favoriteId: String)

    var method: String {
        switch self {
        case .getFavorites: return "GET"
        case .addToFavorites: return "POST"
        case .removeFromFavorites: return "DELETE"
        }
    }

    var path: String {
        switch self {
        case .getFavorites, .addToFavorites: return "/api/favorites"
        case .removeFromFavorites(let favoriteId): return "/api/favorites/\(favoriteId)"
        }
    }
}
