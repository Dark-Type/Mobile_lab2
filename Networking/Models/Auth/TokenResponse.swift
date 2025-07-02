//
//  TokenResponse.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

struct TokenResponse: Codable {
    let jwt: String
    let user: User
}
