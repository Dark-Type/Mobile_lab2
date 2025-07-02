//
//  ReadingProgressCalculator.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

import ComposableArchitecture
import Foundation

enum ReadingProgressCalculator {
    static func calculateTotalSentenceProgress(
        currentParagraphIndex: Int,
        currentSentenceIndex: Int,
        paragraphs: [String]
    ) -> Int {
        var total = 0
        for i in 0 ..< currentParagraphIndex where i < paragraphs.count {
            let sentences = TextProcessingUtils.splitIntoSentences(paragraphs[i])
            total += sentences.count
        }
        total += currentSentenceIndex
        return total
    }

    static func calculateTotalSentencesInChapter(paragraphs: [String]) -> Int {
        var total = 0
        for paragraph in paragraphs {
            let sentences = TextProcessingUtils.splitIntoSentences(paragraph)
            total += sentences.count
        }
        return total
    }

    static func createReadingProgress(
        from state: ChapterReadingFeature.State
    ) -> ReadingProgress {
        _ = calculateTotalSentenceProgress(
            currentParagraphIndex: state.savedParagraphIndex,
            currentSentenceIndex: state.savedSentenceIndex,
            paragraphs: state.paragraphs
        )

        _ = calculateTotalSentencesInChapter(
            paragraphs: state.paragraphs
        )

        return ReadingProgress(
            bookId: state.book.id, totalChapters: 10,
            currentPosition: Double(state.savedParagraphIndex),
            progressPercentage: Double(state.savedSentenceIndex),
            chapterId: state.currentChapter.id
        )
    }
}
