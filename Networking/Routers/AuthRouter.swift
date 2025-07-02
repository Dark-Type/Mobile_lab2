//
//  AuthRouter.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

import Alamofire

enum AuthRouter {
    case register(username: String, email: String, password: String)
    case login(identifier: String, password: String)

    var method: HTTPMethod {
        switch self {
        case .register, .login: return .post
        }
    }

    var path: String {
        switch self {
        case .register:
            return "/api/auth/local/register"
        case .login:
            return "/api/auth/local/"
        }
    }
}
