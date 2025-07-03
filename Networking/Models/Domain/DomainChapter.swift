//
//  DomainChapter.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import Foundation

public struct DomainChapter: Identifiable, Equatable, Codable {
    public let id: String
    public let title: String
    public let number: Int
    public let content: String
    public let paragraphs: [String]

    public init(id: String = UUID().uuidString, title: String, number: Int, content: String) {
        self.id = id
        self.title = title
        self.number = number
        self.content = content
        self.paragraphs = content.components(separatedBy: "\n").filter { !$0.isEmpty }
    }
}
