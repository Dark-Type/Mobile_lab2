//
//  QuoteRouter.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

internal import Alamofire

enum QuoteRouter {
    case getQuotes
    case createQuote

    var method: HTTPMethod {
        switch self {
        case .getQuotes: return .get
        case .createQuote: return .post
        }
    }

    var path: String { "/api/quotes" }
}
