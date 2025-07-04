//
//  QuoteService.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

import Alamofire
import Foundation

public protocol QuoteServiceProtocol: Sendable {
    func getQuotes() async throws -> Quotes
    func createQuote(_ quote: ShortQuote) async throws -> NetworkQuote
}

public final class QuoteService: QuoteServiceProtocol {
    private let session: Session
    private let baseURL: String

    public init(session: Session = .default, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    public func getQuotes() async throws -> Quotes {
        let url = "\(baseURL)\(QuoteRouter.getQuotes.path)"
        return try await session.request(
            url,
            method: QuoteRouter.getQuotes.method
        )
        .validate()
        .serializingDecodable(Quotes.self)
        .value
    }

    public func createQuote(_ quote: ShortQuote) async throws -> NetworkQuote {
        let url = "\(baseURL)\(QuoteRouter.createQuote.path)"
        let createQuote = CreateQuote(data: quote)
        return try await session.request(
            url,
            method: QuoteRouter.createQuote.method,
            parameters: createQuote,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingDecodable(NetworkQuote.self)
        .value
    }
}
