//
//  ReferenceDataRouter.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//
internal import Alamofire

enum ReferenceDataRouter {
    case getAuthors
    case getGenres

    var method: HTTPMethod {
        switch self {
        case .getAuthors, .getGenres: return .get
        }
    }

    var path: String {
        switch self {
        case .getAuthors: return "/api/authors"
        case .getGenres: return "/api/genres"
        }
    }
}
