//
//  DomainBook.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import Foundation

public struct DomainBook: Identifiable, Equatable, Codable {
    public let id: String
    public let title: String
    public let authors: [DomainAuthor]
    public let description: String
    public let coverImageURL: String
    public let posterImageURL: String?
    public let genres: [String]
    public var chapters: [DomainChapter]
    public var chapterProgresses: [String: DomainReadingProgress] = [:] 
    public var isFavorite: Bool = false
    public var isNew: Bool = false

    public init(
        id: String,
        title: String,
        authors: [DomainAuthor],
        description: String,
        coverImageURL: String,
        posterImageURL: String? = nil,
        genres: [String] = [],
        chapters: [DomainChapter] = [],
        chapterProgresses: [String: DomainReadingProgress] = [:],
        isFavorite: Bool = false,
        isNew: Bool = false
    ) {
        self.id = id
        self.title = title
        self.authors = authors
        self.description = description
        self.coverImageURL = coverImageURL
        self.posterImageURL = posterImageURL
        self.genres = genres
        self.chapters = chapters
        self.chapterProgresses = chapterProgresses
        self.isFavorite = isFavorite
        self.isNew = isNew
    }

    public var overallProgress: Double {
        guard !chapters.isEmpty else { return 0.0 }
        let totalProgress = chapterProgresses.values.reduce(0.0) { $0 + $1.progressPercentage }
        return totalProgress / Double(chapters.count)
    }

    public var currentChapterIndex: Int {
        for (index, chapter) in chapters.enumerated() {
            if let progress = chapterProgresses[chapter.id], !progress.isCompleted {
                return index
            }
        }
        return chapters.count - 1
    }
}
