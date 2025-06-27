//
//  AuthenticationServiceProtocol.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

protocol AuthenticationServiceProtocol: Sendable {
    func login(credentials: LoginCredentials) async throws -> User
    func logout() async throws
    func getCurrentUser() async -> User?
}
