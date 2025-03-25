//
//  Chapter.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import Foundation

struct Chapter: Identifiable, Equatable {
    let id: UUID
    let title: String
    let number: Int
    let content: String
    let paragraphs: [String]
    var isStarted: Bool
    var isFinished: Bool

    init(id: UUID = UUID(), title: String, number: Int, content: String, isStarted: Bool = false, isFinished: Bool = false) {
        self.id = id
        self.title = title
        self.number = number
        self.content = content
        self.paragraphs = content.components(separatedBy: "\n").filter { !$0.isEmpty }
        self.isStarted = isStarted
        self.isFinished = isFinished
    }
}
