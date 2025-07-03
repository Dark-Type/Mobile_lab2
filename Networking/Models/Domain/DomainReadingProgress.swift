//
//  DomainReadingProgress.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import Foundation

public struct DomainReadingProgress: Equatable, Codable {
    public let chapterId: String
    public var progressPercentage: Double = 0.0

    public init(chapterId: String, progressPercentage: Double = 0.0) {
        self.chapterId = chapterId
        self.progressPercentage = min(max(progressPercentage, 0.0), 1.0)
    }

    public mutating func updateProgress(_ percentage: Double) {
        progressPercentage = min(max(percentage, 0.0), 1.0)
    }

    public var isCompleted: Bool {
        progressPercentage >= 1.0
    }

    public var isStarted: Bool {
        progressPercentage > 0.0
    }
}
