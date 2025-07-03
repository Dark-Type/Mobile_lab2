//
//  ChapterRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

public protocol ChapterRepositoryProtocol: Sendable {
    func getBookByChapterId(_ chapterId: Int) async throws -> DomainChaptersWithBookAndAuthor
    func getChapterByBookId(_ bookId: Int) async throws -> DomainChaptersWithBookAndAuthor
}

public final class ChapterRepository: ChapterRepositoryProtocol, @unchecked Sendable {
    private let service: ChapterServiceProtocol
    private let chapterByIdCache = TimedMemoryCache<Int, DomainChaptersWithBookAndAuthor>(lifetime: 3600)
    private let chapterByBookIdCache = TimedMemoryCache<Int, DomainChaptersWithBookAndAuthor>(lifetime: 3600)

    public init(service: ChapterServiceProtocol) {
        self.service = service
    }

    public func getBookByChapterId(_ chapterId: Int) async throws -> DomainChaptersWithBookAndAuthor {
        if let cached = await chapterByIdCache.value(for: chapterId) {
            return cached
        }
        let networkData = try await service.getBookByChapterId(chapterId)
        let mapped = networkData.toDomainChaptersWithBookAndAuthor()
        await chapterByIdCache.set(mapped, for: chapterId)
        return mapped
    }

    public func getChapterByBookId(_ bookId: Int) async throws -> DomainChaptersWithBookAndAuthor {
        if let cached = await chapterByBookIdCache.value(for: bookId) {
            return cached
        }
        let networkData = try await service.getChapterByBookId(bookId)
        let mapped = networkData.toDomainChaptersWithBookAndAuthor()
        await chapterByBookIdCache.set(mapped, for: bookId)
        return mapped
    }
}
