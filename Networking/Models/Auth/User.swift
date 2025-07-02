//
//  User.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

struct User: Codable {
    let id: Int
    let documentId: String
    let username: String
    let email: String
    let provider: String
    let confirmed: Bool
    let blocked: Bool
    let createdAt: String
    let updatedAt: String
    let publishedAt: String
}
