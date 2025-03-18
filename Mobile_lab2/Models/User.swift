//
//  User.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

struct User: Codable {
    var email: String
    var password: String

    static let example = User(
        email: "johndoe@example.com",
        password: "password123"
    )
}
