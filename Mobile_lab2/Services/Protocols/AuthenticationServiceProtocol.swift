//
//  AuthenticationServiceProtocol.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import Dependencies

protocol AuthenticationServiceProtocol: Sendable {
    func login(credentials: LoginCredentials) async throws -> User
    func logout() async throws
    func getCurrentUser() async -> User?
}

struct AuthenticationServiceKey: DependencyKey {
    static let liveValue: AuthenticationServiceProtocol = MockAuthenticationService()
    static let testValue: AuthenticationServiceProtocol = MockAuthenticationService()
}

extension DependencyValues {
    var authenticationService: AuthenticationServiceProtocol {
        get { self[AuthenticationServiceKey.self] }
        set { self[AuthenticationServiceKey.self] = newValue }
    }
}
