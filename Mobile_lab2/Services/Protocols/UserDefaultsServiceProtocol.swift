//
//  UserDefaultsServiceProtocol.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

protocol UserDefaultsServiceProtocol: Sendable {
    func setCurrentBookID(_ bookID: String) async
    func getCurrentBookID() async -> String
    func setFavoriteBookIDs(_ bookIDs: [String]) async
    func getFavoriteBookIDs() async -> [String]
    func setLoggedIn(_ isLoggedIn: Bool) async
    func isLoggedIn() async -> Bool
}
