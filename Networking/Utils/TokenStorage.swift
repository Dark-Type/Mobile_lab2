//
//  TokenStorage.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

import Foundation

protocol TokenStorage: Sendable {
    func getToken() async -> String?
    func setToken(_ token: String?) async
    func removeToken() async
}

final class UserDefaultsTokenStorage: TokenStorage {
    private let key = "auth_token"

    func getToken() async -> String? {
        UserDefaults.standard.string(forKey: key)
    }

    func setToken(_ token: String?) async {
        if let token = token {
            UserDefaults.standard.set(token, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    func removeToken() async {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
