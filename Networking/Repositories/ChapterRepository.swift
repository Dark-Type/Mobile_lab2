//
//  ChapterRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

public protocol ChapterRepositoryProtocol: Sendable {
    func getBookByChapterId(_ chapterId: Int) async throws -> ChaptersWithBookAndAuthor
    func getChapterByBookId(_ bookId: Int) async throws -> ChaptersWithBookAndAuthor
}

public final class ChapterRepository: ChapterRepositoryProtocol, @unchecked Sendable {
    private let service: ChapterServiceProtocol
    private let chapterByIdCache = TimedMemoryCache<Int, ChaptersWithBookAndAuthor>(lifetime: 3600)
    private let chapterByBookIdCache = TimedMemoryCache<Int, ChaptersWithBookAndAuthor>(lifetime: 3600)

    public init(service: ChapterServiceProtocol) {
        self.service = service
    }

    public func getBookByChapterId(_ chapterId: Int) async throws -> ChaptersWithBookAndAuthor {
        if let cached = await chapterByIdCache.value(for: chapterId) {
            return cached
        }
        let loaded = try await service.getBookByChapterId(chapterId)
        await chapterByIdCache.set(loaded, for: chapterId)
        return loaded
    }

    public func getChapterByBookId(_ bookId: Int) async throws -> ChaptersWithBookAndAuthor {
        if let cached = await chapterByBookIdCache.value(for: bookId) {
            return cached
        }
        let loaded = try await service.getChapterByBookId(bookId)
        await chapterByBookIdCache.set(loaded, for: bookId)
        return loaded
    }
}
