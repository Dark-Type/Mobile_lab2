//
//  ReferenceDataService.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

internal import Alamofire
import Foundation

protocol ReferenceDataServiceProtocol: Sendable {
    func getAuthors() async throws -> Authors
    func getGenres() async throws -> Genres
}

final class ReferenceDataService: ReferenceDataServiceProtocol {
    private let session: Session
    private let baseURL: String

    init(session: Session = .shared, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    func getAuthors() async throws -> Authors {
        let url = "\(baseURL)\(ReferenceDataRouter.getAuthors.path)"
        return try await session.request(
            url,
            method: ReferenceDataRouter.getAuthors.method
        )
        .validate()
        .serializingDecodable(Authors.self)
        .value
    }

    func getGenres() async throws -> Genres {
        let url = "\(baseURL)\(ReferenceDataRouter.getGenres.path)"
        return try await session.request(
            url,
            method: ReferenceDataRouter.getGenres.method
        )
        .validate()
        .serializingDecodable(Genres.self)
        .value
    }
}
