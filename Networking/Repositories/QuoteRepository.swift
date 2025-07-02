//
//  QuoteRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

public protocol QuoteRepositoryProtocol: Sendable {
    func getQuotes() async throws -> Quotes
    func createQuote(_ quote: ShortQuote) async throws -> Quote
}

public final class QuoteRepository: QuoteRepositoryProtocol {
    private let service: QuoteServiceProtocol

    public init(service: QuoteServiceProtocol) {
        self.service = service
    }

    public func getQuotes() async throws -> Quotes {
        try await service.getQuotes()
    }

    public func createQuote(_ quote: ShortQuote) async throws -> Quote {
        try await service.createQuote(quote)
    }
}
