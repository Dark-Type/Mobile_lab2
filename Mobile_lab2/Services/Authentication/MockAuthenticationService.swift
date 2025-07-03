//
//  MockAuthenticationService.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import Dependencies
import Foundation
//
//struct MockAuthenticationService: AuthenticationServiceProtocol {
//    func login(credentials: LoginCredentials) async throws -> UserUI {
//        try await Task.sleep(nanoseconds: 1_000_000_000)
//
//        guard credentials.isValid else {
//            throw AuthenticationError.invalidCredentials
//        }
//
//        return UserUI(email: credentials.email, name: "Mock User")
//    }
//
//    func logout() async throws {
//        try await Task.sleep(nanoseconds: 500_000_000)
//    }
//
//    func getCurrentUser() async -> UserUI? {
//        return UserUI(email: "mock@example.com", name: "Mock User")
//    }
//}
//
//// MARK: - Dependency Registration
//
//extension MockAuthenticationService: DependencyKey {
//    static let liveValue: AuthenticationServiceProtocol = MockAuthenticationService()
//    static let testValue: AuthenticationServiceProtocol = MockAuthenticationService()
//}
//
//extension DependencyValues {
//    var authenticationService: AuthenticationServiceProtocol {
//        get { self[MockAuthenticationService.self] }
//        set { self[MockAuthenticationService.self] = newValue }
//    }
//}
