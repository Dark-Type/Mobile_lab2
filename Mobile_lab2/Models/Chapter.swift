//
//  Chapter.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import Foundation

public struct Chapter: Identifiable, Equatable, Sendable {
    public let id: UUID
    let title: String
    let number: Int
    let content: String
    let paragraphs: [String]

    init(id: UUID = UUID(), title: String, number: Int, content: String) {
        self.id = id
        self.title = title
        self.number = number
        self.content = content
        self.paragraphs = content.components(separatedBy: "\n").filter { !$0.isEmpty }
    }
    
    func isStarted(progress: ReadingProgress?) -> Bool {
        progress?.isStarted ?? false
    }
    
    func isFinished(progress: ReadingProgress?) -> Bool {
        progress?.isCompleted ?? false
    }
}
