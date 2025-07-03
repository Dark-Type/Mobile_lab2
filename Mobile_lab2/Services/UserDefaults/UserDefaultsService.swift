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

    func setCredentials(email: String, password: String) async {
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(password, forKey: "userPassword")
    }

    func getCredentials() async -> (email: String, password: String)? {
        guard let email = UserDefaults.standard.string(forKey: "userEmail"),
              let password = UserDefaults.standard.string(forKey: "userPassword")
        else {
            return nil
        }
        return (email, password)
    }

    func removeCredentials() async {
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userPassword")
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


