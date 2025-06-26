//
//  MockAuthenticationService.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import Foundation

struct MockAuthenticationService: AuthenticationServiceProtocol {
    func login(credentials: LoginCredentials) async throws -> User {
        try await Task.sleep(nanoseconds: 1_000_000_000)

        guard credentials.isValid else {
            throw AuthenticationError.invalidCredentials
        }

        return User(email: credentials.email, name: "Mock User")
    }

    func logout() async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
    }

    func getCurrentUser() async -> User? {
        return User(email: "mock@example.com", name: "Mock User")
    }
}
