//
//  QuoteRouter.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

enum QuoteRouter {
    case getQuotes
    case createQuote

    var method: String {
        switch self {
        case .getQuotes: return "GET"
        case .createQuote: return "POST"
        }
    }

    var path: String { "/api/quotes" }
}
