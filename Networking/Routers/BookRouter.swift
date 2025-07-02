//
//  BookRouter.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

import Alamofire

enum BookRouter {
    case getBooks(page: Int, pageSize: Int)
    case getBooksById(id: Int)
    case getBooksByName(name: String)
    case getBooksByGenre(genreId: Int)
    case getBooksByAuthor(authorId: Int)
    case getNewBooks(isNew: Bool)
    case getBooksWithAuthors(page: Int, pageSize: Int)

    var method: HTTPMethod { .get }
    var path: String { "/api/books" }

    var query: [String: Any] {
        switch self {
        case let .getBooks(page, pageSize):
            return [
                "pagination[page]": page,
                "pagination[pageSize]": pageSize,
                "populate[0]": "authors"
            ]
        case let .getBooksById(id):
            return [
                "filters[id]": id,
                "populate[0]": "authors"
            ]
        case let .getBooksByName(name):
            return [
                "filters[title][$containsi]": name,
                "populate[0]": "authors"
            ]
        case let .getBooksByGenre(genreId):
            return [
                "filters[genres][id][$eq]": genreId,
                "populate[0]": "authors"
            ]
        case let .getBooksByAuthor(authorId):
            return [
                "filters[authors][id][$eq]": authorId,
                "populate[0]": "authors"
            ]
        case let .getNewBooks(isNew):
            return [
                "filters[isNew]": isNew
            ]
        case let .getBooksWithAuthors(page, pageSize):
            return [
                "pagination[page]": page,
                "pagination[pageSize]": pageSize,
                "populate[0]": "authors"
            ]
        }
    }
}
