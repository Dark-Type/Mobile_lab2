//
//  UserDefaultsService.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//
import Dependencies
import Foundation

struct UserDefaultsService: UserDefaultsServiceProtocol {
    func setCurrentBookID(_ bookID: String) async {
        UserDefaults.standard.set(bookID, forKey: "currentBookID")
    }

    func getCurrentBookID() async -> String {
        UserDefaults.standard.string(forKey: "currentBookID") ?? ""
    }

    func setFavoriteBookIDs(_ bookIDs: [String]) async {
        let favoriteString = bookIDs.joined(separator: ",")
        UserDefaults.standard.set(favoriteString, forKey: "favoriteBookIDs")
    }

    func getFavoriteBookIDs() async -> [String] {
        let favoriteString = UserDefaults.standard.string(forKey: "favoriteBookIDs") ?? ""
        return favoriteString.isEmpty ? [] : favoriteString.split(separator: ",").map(String.init)
    }

    func setLoggedIn(_ isLoggedIn: Bool) async {
        UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
    }

    func getLoggedIn() async -> Bool {
        UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}

// MARK: - Dependency Registration

extension UserDefaultsService: DependencyKey {
    static let liveValue: UserDefaultsServiceProtocol = UserDefaultsService()
    static let testValue: UserDefaultsServiceProtocol = UserDefaultsService()
}

extension DependencyValues {
    var userDefaultsService: UserDefaultsServiceProtocol {
        get { self[UserDefaultsService.self] }
        set { self[UserDefaultsService.self] = newValue }
    }
}
