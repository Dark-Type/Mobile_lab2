//
//  ReadingProgress.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import Foundation

public struct ReadingProgress: Equatable {
    let chapterId: UUID
    var progressPercentage: Double = 0.0
    
    init(chapterId: UUID, progressPercentage: Double = 0.0) {
        self.chapterId = chapterId
        self.progressPercentage = min(max(progressPercentage, 0.0), 1.0)
    }
    
    mutating func updateProgress(_ percentage: Double) {
        self.progressPercentage = min(max(percentage, 0.0), 1.0)
    }
    
    var isCompleted: Bool {
        progressPercentage >= 1.0
    }
    
    var isStarted: Bool {
        progressPercentage > 0.0
    }
}
