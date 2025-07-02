//
//  AuthRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

import Alamofire

public protocol AuthRepositoryProtocol: Sendable {
    func register(_ request: RegisterRequest) async throws -> TokenResponse
    func refresh(_ request: RefreshRequest) async throws -> TokenResponse
    func saveToken(_ token: String) async
    func getToken() async -> String?
    func removeToken() async
}

public final class AuthRepository: AuthRepositoryProtocol {
    private let service: AuthServiceProtocol
    private let tokenStorage: TokenStorage

    public init(service: AuthServiceProtocol, tokenStorage: TokenStorage) {
        self.service = service
        self.tokenStorage = tokenStorage
    }

    public func register(_ request: RegisterRequest) async throws -> TokenResponse {
        let response = try await service.register(request)
        await tokenStorage.setToken(response.jwt)
        return response
    }

    public func refresh(_ request: RefreshRequest) async throws -> TokenResponse {
        let response = try await service.login(request)
        await tokenStorage.setToken(response.jwt)
        return response
    }

    public func saveToken(_ token: String) async {
        await tokenStorage.setToken(token)
    }

    public func getToken() async -> String? {
        await tokenStorage.getToken()
    }

    public func removeToken() async {
        await tokenStorage.removeToken()
    }
}
