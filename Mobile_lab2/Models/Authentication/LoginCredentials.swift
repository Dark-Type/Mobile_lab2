//
//  LoginCredentials.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

struct LoginCredentials: Equatable {
    let email: String
    let password: String

    var isValid: Bool {
        !email.isEmpty && !password.isEmpty && email.contains("@")
    }
}
