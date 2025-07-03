//
//  NetworkToDomainMapping.swift
//  Networking
//
//  Created by dark type on 03.07.2025.
//
import Foundation

// MARK: - Books Mapping

public extension Books {
    func toDomainBooks() -> [DomainBook] {
        return data.map { $0.toDomainBook() }
    }
}

// MARK: - Book Mapping

public extension Book {
    func toDomainBook() -> DomainBook {
        return DomainBook(
            id: documentId,
            title: title,
            authors: author.map { $0.toDomainAuthor() },
            description: description,
            coverImageURL: coverURL,
            posterImageURL: illustrationURL,
            genres: [],
            chapters: [],
            chapterProgresses: [:],
            isFavorite: false,
            isNew: isNew
        )
    }
}

// MARK: - BookWithShortAuthors Mapping

public extension BookWithShortAuthors {
    func toDomainBook() -> DomainBook {
        return DomainBook(
            id: documentId,
            title: title,
            authors: authors.map { $0.toDomainAuthor() },
            description: description,
            coverImageURL: coverURL,
            posterImageURL: illustrationURL,
            genres: [],
            chapters: [],
            chapterProgresses: [:],
            isFavorite: false,
            isNew: isNew
        )
    }
}

// MARK: - Author Mapping

public extension AuthorDTO {
    func toDomainAuthor() -> DomainAuthor {
        return DomainAuthor(
            id: documentId,
            name: name,
            avatarURL: ""
        )
    }
}

// MARK: - ShortAuthor Mapping

public extension ShortAuthor {
    func toDomainAuthor() -> DomainAuthor {
        return DomainAuthor(
            id: documentId,
            name: name,
            avatarURL: avatarURL
        )
    }
}

// MARK: - Chapter Mapping

public extension ChapterDTO {
    func toDomainChapter() -> DomainChapter {
        return DomainChapter(
            id: documentId,
            title: title,
            number: order,
            content: text
        )
    }
}

// MARK: - ChapterWithBookAndAuthor Mapping

public extension ChapterWithBookAndAuthor {
    func toDomainChapter() -> DomainChapter {
        return DomainChapter(
            id: documentId,
            title: title,
            number: order,
            content: text
        )
    }

    func toDomainBook() -> DomainBook {
        return book.toDomainBook()
    }
}

// MARK: - Array Extensions for Bulk Mapping

public extension Array where Element == BookWithShortAuthors {
    func toDomainBooks() -> [DomainBook] {
        return self.map { $0.toDomainBook() }
    }
}

public extension Array where Element == ChapterDTO {
    func toDomainChapters() -> [DomainChapter] {
        return self.map { $0.toDomainChapter() }
    }
}

public extension Array where Element == AuthorDTO {
    func toDomainAuthors() -> [DomainAuthor] {
        return self.map { $0.toDomainAuthor() }
    }
}

public extension Array where Element == ShortAuthor {
    func toDomainAuthors() -> [DomainAuthor] {
        return self.map { $0.toDomainAuthor() }
    }
}

public extension ChaptersWithBookAndAuthor {
    func toDomainChaptersWithBookAndAuthor() -> DomainChaptersWithBookAndAuthor {
        return DomainChaptersWithBookAndAuthor(
            chapters: data.map { $0.toDomainChapterWithBook() }
        )
    }
}

public extension ChapterWithBookAndAuthor {
    func toDomainChapterWithBook() -> DomainChapterWithBook {
        return DomainChapterWithBook(
            id: documentId,
            title: title,
            number: order,
            content: text,
            book: book.toDomainBook()
        )
    }
}

// MARK: - Favorites Mapping

public extension Favorites {
    func toDomainFavorites() -> DomainFavorites {
        return DomainFavorites(
            favorites: data.map { $0.toDomainFavorite() }
        )
    }
}

public extension Favorite {
    func toDomainFavorite() -> DomainFavorite {
        return DomainFavorite(
            id: documentId,
            bookId: bookId.description,
            createdAt: createdAt
        )
    }
}

public extension AddFavoriteRequest {
    func toDomainAddFavoriteRequest() -> DomainAddFavoriteRequest {
        return DomainAddFavoriteRequest(bookId: String(self.data.bookId))
    }
}

// MARK: - Progress Mapping

public extension Progresses {
    func toDomainProgresses() -> DomainProgresses {
        return DomainProgresses(
            progresses: data.map { $0.toDomainProgress() }
        )
    }
}

public extension Progress {
    func toDomainProgress() -> DomainProgress {
        return DomainProgress(
            id: documentId,
            value: Double(value),
            chapterId: chapterId.description,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public extension ShortProgress {
    func toDomainShortProgress() -> DomainShortProgress {
        return DomainShortProgress(
            value: Double(value),
            chapterId: chapterId.description
        )
    }
}

// MARK: - Reference Data Mapping

public extension Authors {
    func toDomainAuthors() -> DomainAuthors {
        return DomainAuthors(
            authors: data.map { $0.toDomainAuthor() }
        )
    }
}

public extension Genres {
    func toDomainGenres() -> DomainGenres {
        return DomainGenres(
            genres: data.map { $0.toDomainGenre() }
        )
    }
}

public extension Genre {
    func toDomainGenre() -> DomainGenre {
        return DomainGenre(
            id: documentId,
            name: name
        )
    }
}

// MARK: - Reverse Mapping (Domain to Network) for requests

public extension DomainAddFavoriteRequest {
    func toAddFavoriteRequest() -> AddFavoriteRequest {
        return AddFavoriteRequest(
            data: BookId(bookId: Int(bookId) ?? 0)
        )
    }
}

public extension DomainShortProgress {
    func toShortProgress() -> ShortProgress {
        return ShortProgress(
            value: Int(value),
            chapterId: Int(chapterId) ?? 0
        )
    }
}
