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

    func setLoggedIn(_ isLoggedIn: Bool) async {
        UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
    }

    func getLoggedIn() async -> Bool {
        UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    func addSearchRequest(_ request: String) async {
        var requests: [String] = []
        if let savedRequests = UserDefaults.standard.array(forKey: "searchRequests") as? [String] {
            requests = savedRequests
        }
        requests.append(request)
        UserDefaults.standard.set(requests, forKey: "searchRequests")
    }
    func getSearchRequests() async -> [String] {
        (UserDefaults.standard.array(forKey: "searchRequests") as? [String]) ?? []
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
