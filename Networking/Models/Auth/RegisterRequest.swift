//
//  RegisterRequest.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

public struct RegisterRequest: Codable {
    public init(email: String, password: String, username: String) {
        self.email = email
        self.password = password
        self.username = username
    }

    let email: String
    let password: String
    let username: String
}

public extension RegisterRequest {
    var isValid: Bool {
        !email.isEmpty && !password.isEmpty && email.contains("@")
    }
}
