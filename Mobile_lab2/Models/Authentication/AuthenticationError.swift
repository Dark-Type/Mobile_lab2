//
//  AuthenticationError.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

struct AuthenticationError: Error, Equatable {
    let message: String
    let code: String

    static let invalidCredentials = AuthenticationError(
        message: "Invalid email or password",
        code: "INVALID_CREDENTIALS"
    )

    static let networkError = AuthenticationError(
        message: "Network connection failed",
        code: "NETWORK_ERROR"
    )
}
