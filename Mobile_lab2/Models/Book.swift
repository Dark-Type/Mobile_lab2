//
//  Book.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct Book: Identifiable {
    let id: UUID
    let title: String
    let author: [Author]
    let description: String
    let coverImage: Image
    let posterImage: Image
    let genres: [String]
    let chapters: [Chapter]
    var userProgress: ReadingProgress
    var isFavorite: Bool = false

    init(id: UUID = UUID(), title: String, author: [Author], description: String, coverImage: Image, posterImage: Image, genres: [String], chapters: [Chapter], userProgress: ReadingProgress? = nil, isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.author = author
        self.description = description
        self.coverImage = coverImage
        self.posterImage = posterImage
        self.genres = genres
        self.chapters = chapters
        self.userProgress = userProgress ?? ReadingProgress(
            bookId: id,
            totalChapters: chapters.count,
            currentChapter: 0,
            currentPosition: 0.0
        )
        self.isFavorite = isFavorite
    }
}
