//
//  User.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import Foundation

struct User: Equatable, Codable {
    let id: String
    let email: String
    let name: String?

    init(id: String = UUID().uuidString, email: String, name: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
    }

    static let mockUser = User(email: "mock@example.com", name: "Mock User")
}
