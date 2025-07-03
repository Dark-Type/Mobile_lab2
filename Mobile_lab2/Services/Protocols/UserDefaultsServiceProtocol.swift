//
//  UserDefaultsServiceProtocol.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

protocol UserDefaultsServiceProtocol: Sendable {
    func setCurrentBookID(_ bookID: String) async
    func getCurrentBookID() async -> String
    func setLoggedIn(_ isLoggedIn: Bool) async
    func getLoggedIn() async -> Bool
    func addSearchRequest(_ request: String) async
    func getSearchRequests() async -> [String]
}
