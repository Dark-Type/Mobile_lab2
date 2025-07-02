//
//  QuoteService.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

internal import Alamofire
import Foundation

protocol QuoteServiceProtocol: Sendable {
    func getQuotes() async throws -> Quotes
    func createQuote(_ quote: ShortQuote) async throws -> Quote
}

final class QuoteService: QuoteServiceProtocol {
    private let session: Session
    private let baseURL: String

    init(session: Session = .shared, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    func getQuotes() async throws -> Quotes {
        let url = "\(baseURL)\(QuoteRouter.getQuotes.path)"
        return try await session.request(
            url,
            method: QuoteRouter.getQuotes.method
        )
        .validate()
        .serializingDecodable(Quotes.self)
        .value
    }

    func createQuote(_ quote: ShortQuote) async throws -> Quote {
        let url = "\(baseURL)\(QuoteRouter.createQuote.path)"
        let createQuote = CreateQuote(data: quote)
        return try await session.request(
            url,
            method: QuoteRouter.createQuote.method,
            parameters: createQuote,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingDecodable(Quote.self)
        .value
    }
}
