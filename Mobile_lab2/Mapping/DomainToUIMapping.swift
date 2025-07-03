//
//  Mapping.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//


import Foundation
import Networking

// MARK: - DomainBook to BookUI Mapping
extension DomainBook {
    func toBookUI() -> BookUI {
        let uiChapterProgresses: [UUID: ReadingProgress] = Dictionary(
            uniqueKeysWithValues: self.chapterProgresses.compactMap { (stringKey, domainProgress) in
                guard let uuidKey = UUID(uuidString: stringKey) else { return nil }
                return (uuidKey, domainProgress.toReadingProgressUI())
            }
        )
        
        return BookUI(
            id: self.id,
            title: self.title,
            author: self.authors.map { $0.toAuthorUI() },
            description: self.description,
            coverImageURL: self.coverImageURL,
            posterImageURL: self.posterImageURL,
            genres: self.genres,
            chapters: self.chapters.map { $0.toChapterUI() },
            chapterProgresses: uiChapterProgresses,
            isFavorite: self.isFavorite,
            isNew: self.isNew
        )
    }
}

// MARK: - DomainAuthor to Author Mapping
extension DomainAuthor {
    func toAuthorUI() -> Author {
        return Author(
            id: self.id,
            name: self.name,
            avatarURL: self.avatarURL
        )
    }
}

// MARK: - DomainChapter to Chapter Mapping
extension DomainChapter {
    func toChapterUI() -> Chapter {
        let chapterUUID = UUID(uuidString: self.id) ?? UUID()
        
        return Chapter(
            id: chapterUUID,
            title: self.title,
            number: self.number,
            content: self.content
        )
    }
}

// MARK: - DomainReadingProgress to ReadingProgress Mapping
extension DomainReadingProgress {
    func toReadingProgressUI() -> ReadingProgress {
        let chapterUUID = UUID(uuidString: self.chapterId) ?? UUID()
        
        return ReadingProgress(
            chapterId: chapterUUID,
            progressPercentage: self.progressPercentage
        )
    }
}

// MARK: - Array Extensions for Bulk Mapping
extension Array where Element == DomainBook {
    func toBooksUI() -> [BookUI] {
        return self.map { $0.toBookUI() }
    }
}

extension Array where Element == DomainAuthor {
    func toAuthorsUI() -> [Author] {
        return self.map { $0.toAuthorUI() }
    }
}

extension Array where Element == DomainChapter {
    func toChaptersUI() -> [Chapter] {
        return self.map { $0.toChapterUI() }
    }
}

// MARK: - Reverse Mapping (UI to Domain) - For saving data back to network
extension BookUI {
    func toDomainBook() -> DomainBook {
        let domainChapterProgresses: [String: DomainReadingProgress] = Dictionary(
            uniqueKeysWithValues: self.chapterProgresses.map { (uuidKey, uiProgress) in
                (uuidKey.uuidString, uiProgress.toDomainReadingProgress())
            }
        )
        
        return DomainBook(
            id: self.id,
            title: self.title,
            authors: self.author.map { $0.toDomainAuthor() },
            description: self.description,
            coverImageURL: self.coverImageURL,
            posterImageURL: self.posterImageURL,
            genres: self.genres,
            chapters: self.chapters.map { $0.toDomainChapter() },
            chapterProgresses: domainChapterProgresses,
            isFavorite: self.isFavorite,
            isNew: self.isNew
        )
    }
}

extension Author {
    func toDomainAuthor() -> DomainAuthor {
        return DomainAuthor(
            id: self.id,
            name: self.name,
            avatarURL: self.avatarURL
        )
    }
}

extension Chapter {
    func toDomainChapter() -> DomainChapter {
        return DomainChapter(
            id: self.id.uuidString,
            title: self.title,
            number: self.number,
            content: self.content
        )
    }
}

extension ReadingProgress {
    func toDomainReadingProgress() -> DomainReadingProgress {
        return DomainReadingProgress(
            chapterId: self.chapterId.uuidString,
            progressPercentage: self.progressPercentage
        )
    }
}

extension DomainChaptersWithBookAndAuthor {
    func toChaptersUI() -> [Chapter] {
        return chapters.map { $0.toChapterUI() }
    }
    
    func toBooksUI() -> [BookUI] {
        return chapters.map { $0.book.toBookUI() }
    }
}

extension DomainChapterWithBook {
    func toChapterUI() -> Chapter {
        let chapterUUID = UUID(uuidString: self.id) ?? UUID()
        
        return Chapter(
            id: chapterUUID,
            title: self.title,
            number: self.number,
            content: self.content
        )
    }
    
    func toBookUI() -> BookUI {
        return book.toBookUI()
    }
}

extension DomainFavorites {
    func toFavoriteBookIds() -> Set<String> {
        return Set(favorites.map { $0.bookId })
    }
}

extension DomainProgresses {
    func toChapterProgressMap() -> [String: Double] {
        return Dictionary(uniqueKeysWithValues: progresses.map { ($0.chapterId, $0.value) })
    }
}

extension DomainGenres {
    func toGenreNames() -> [String] {
        return genres.map { $0.name }
    }
}

// MARK: - UI to Domain mappings for sending data back

extension BookUI {
    func toAddFavoriteRequest() -> DomainAddFavoriteRequest {
        return DomainAddFavoriteRequest(bookId: self.id)
    }
}

extension ReadingProgress {
    func toDomainShortProgress() -> DomainShortProgress {
        return DomainShortProgress(
            value: self.progressPercentage,
            chapterId: self.chapterId.uuidString
        )
    }
}
