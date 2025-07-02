//
//  ReadingProgress.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import Foundation

struct ReadingProgress: Equatable {
    let bookId: UUID
    var currentChapter: Int = 0
    var paragraphIndex: Int = 0
    var sentenceIndex: Int = 0
    var progressPercentage: Double = 0.0
    var currentPosition: Double = 0.0
    var overallProgress: Double = 0.0
    let totalChapters: Int
    let chapterId: UUID

    init(bookId: UUID, totalChapters: Int, currentChapter: Int = 0, currentPosition: Double = 0.0, progressPercentage: Double = 0.0, paragraphIndex: Int = 0, sentenceIndex: Int = 0, chapterId: UUID = UUID()) {
        self.bookId = bookId
        self.totalChapters = totalChapters
        self.currentChapter = currentChapter
        self.currentPosition = currentPosition
        self.paragraphIndex = paragraphIndex
        self.sentenceIndex = sentenceIndex
        self.progressPercentage = progressPercentage
        self.chapterId = chapterId
        self.overallProgress = calculateOverallProgress()
    }

    private func calculateOverallProgress() -> Double {
        if totalChapters == 0 {
            return 0.0
        }
        let chapterWeight = 1.0 / Double(totalChapters)
        let completedChaptersProgress = Double(currentChapter) * chapterWeight
        let currentChapterProgress = currentPosition * chapterWeight

        return completedChaptersProgress + currentChapterProgress
    }

    mutating func updateProgress(chapter: Int, position: Double) {
        currentChapter = chapter
        currentPosition = position
        overallProgress = calculateOverallProgress()
    }
}
