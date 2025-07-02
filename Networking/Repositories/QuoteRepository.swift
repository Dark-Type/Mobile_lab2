//
//  QuoteRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

protocol QuoteRepositoryProtocol: Sendable {
    func getQuotes() async throws -> Quotes
    func createQuote(_ quote: ShortQuote) async throws -> Quote
}

final class QuoteRepository: QuoteRepositoryProtocol {
    private let service: QuoteServiceProtocol

    init(service: QuoteServiceProtocol) {
        self.service = service
    }

    func getQuotes() async throws -> Quotes {
        try await service.getQuotes()
    }

    func createQuote(_ quote: ShortQuote) async throws -> Quote {
        try await service.createQuote(quote)
    }
}
