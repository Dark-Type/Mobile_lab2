//
//  ReferenceDataService.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

import Alamofire
import Foundation

public protocol ReferenceDataServiceProtocol: Sendable {
    func getAuthors() async throws -> Authors
    func getGenres() async throws -> Genres
}

public final class ReferenceDataService: ReferenceDataServiceProtocol {
    private let session: Session
    private let baseURL: String

    public init(session: Session = .default, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    public func getAuthors() async throws -> Authors {
        let url = "\(baseURL)\(ReferenceDataRouter.getAuthors.path)"
        return try await session.request(
            url,
            method: ReferenceDataRouter.getAuthors.method
        )
        .validate()
        .serializingDecodable(Authors.self)
        .value
    }

    public func getGenres() async throws -> Genres {
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
