//
//  BookServiceProtocol.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

protocol BookServiceProtocol: Sendable {
    func getCurrentBook() async -> Book?
    func setCurrentBook(_ book: Book) async
}
