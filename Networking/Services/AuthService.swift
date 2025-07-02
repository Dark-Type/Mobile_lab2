//
//  AuthService.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

internal import Alamofire

protocol AuthServiceProtocol: Sendable {
    func register(_ request: RegisterRequest) async throws -> TokenResponse
    func login(_ request: RefreshRequest) async throws -> TokenResponse
}

final class AuthService: AuthServiceProtocol {
    private let session: Session
    private let baseURL: String

    init(session: Session, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    func register(_ request: RegisterRequest) async throws -> TokenResponse {
        let router = AuthRouter.register(username: request.username, email: request.email, password: request.password)
        let url = "\(baseURL)\(router.path)"
        return try await session.request(
            url,
            method: router.method,
            parameters: request,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingDecodable(TokenResponse.self)
        .value
    }

    func login(_ request: RefreshRequest) async throws -> TokenResponse {
        let router = AuthRouter.login(identifier: request.identifier, password: request.password)
        let url = "\(baseURL)\(router.path)"
        return try await session.request(
            url,
            method: router.method,
            parameters: request,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingDecodable(TokenResponse.self)
        .value
    }
}
