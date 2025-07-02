//
//  AuthorRouter.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

enum AuthorRouter {
    case getAuthors

    var method: String { "GET" }
    var path: String { "/api/authors" }
}
