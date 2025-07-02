//
//  AuthRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

internal import Alamofire

protocol AuthRepositoryProtocol: Sendable {
    func register(_ request: RegisterRequest) async throws -> TokenResponse
    func login(_ request: RefreshRequest) async throws -> TokenResponse
    func saveToken(_ token: String) async
    func getToken() async -> String?
    func removeToken() async
}

final class AuthRepository: AuthRepositoryProtocol {
    private let service: AuthServiceProtocol
    private let tokenStorage: TokenStorage

    init(service: AuthServiceProtocol, tokenStorage: TokenStorage) {
        self.service = service
        self.tokenStorage = tokenStorage
    }

    func register(_ request: RegisterRequest) async throws -> TokenResponse {
        let response = try await service.register(request)
        await tokenStorage.setToken(response.jwt)
        return response
    }

    func login(_ request: RefreshRequest) async throws -> TokenResponse {
        let response = try await service.login(request)
        await tokenStorage.setToken(response.jwt)
        return response
    }

    func saveToken(_ token: String) async {
        await tokenStorage.setToken(token)
    }

    func getToken() async -> String? {
        await tokenStorage.getToken()
    }

    func removeToken() async {
        await tokenStorage.removeToken()
    }
}
