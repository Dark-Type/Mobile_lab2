//
//  Book.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI
import Networking

public struct BookUI: Identifiable, Equatable, Sendable {
    public static func == (lhs: BookUI, rhs: BookUI) -> Bool {
        return lhs.id == rhs.id
    }

    public let id: String
    let title: String
    let author: [Author]
    let description: String
    let coverImageURL: String
    let posterImageURL: String?
    let genres: [String]
    var chapters: [Chapter]
    var chapterProgresses: [UUID: ReadingProgress] = [:] 
    var isFavorite: Bool = false
    var isNew: Bool = false

    public init(
        id: String = UUID().uuidString,
        title: String,
        author: [Author],
        description: String,
        coverImageURL: String,
        posterImageURL: String? = nil,
        genres: [String],
        chapters: [Chapter],
        chapterProgresses: [UUID: ReadingProgress] = [:],
        isFavorite: Bool = false,
        isNew: Bool = false
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.description = description
        self.coverImageURL = coverImageURL
        self.posterImageURL = posterImageURL
        self.genres = genres
        self.chapters = chapters
        self.isFavorite = isFavorite
        self.isNew = isNew

        var progresses = chapterProgresses
        for chapter in chapters {
            if progresses[chapter.id] == nil {
                progresses[chapter.id] = ReadingProgress(chapterId: chapter.id)
            }
        }
        self.chapterProgresses = progresses
    }

    var overallProgress: Double {
        guard !self.chapters.isEmpty else { return 0.0 }
        let totalProgress = self.chapterProgresses.values.reduce(0.0) { $0 + $1.progressPercentage }
        return totalProgress / Double(self.chapters.count)
    }

    var currentChapterIndex: Int {
        for (index, chapter) in self.chapters.enumerated() {
            if let progress = chapterProgresses[chapter.id], !progress.isCompleted {
                return index
            }
        }
        return self.chapters.count - 1
    }

    mutating func updateChapterProgress(chapterId: UUID, percentage: Double) {
        self.chapterProgresses[chapterId]?.updateProgress(percentage)
    }
}

