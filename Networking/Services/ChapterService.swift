//
//  ChapterService.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

internal import Alamofire
import Foundation

protocol ChapterServiceProtocol: Sendable {
    func getBookByChapterId(_ chapterId: Int) async throws -> ChaptersWithBookAndAuthor
    func getChapterByBookId(_ bookId: Int) async throws -> ChaptersWithBookAndAuthor
}

final class ChapterService: ChapterServiceProtocol {
    private let session: Session
    private let baseURL: String

    init(session: Session = .shared, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    func getBookByChapterId(_ chapterId: Int) async throws -> ChaptersWithBookAndAuthor {
        let router = ChapterRouter.getBookByChapterId(chapterId: chapterId)
        let url = "\(baseURL)\(router.path)"
        return try await session.request(
            url,
            method: router.method,
            parameters: router.query,
            encoding: URLEncoding.default
        )
        .validate()
        .serializingDecodable(ChaptersWithBookAndAuthor.self)
        .value
    }

    func getChapterByBookId(_ bookId: Int) async throws -> ChaptersWithBookAndAuthor {
        let router = ChapterRouter.getChapterByBookId(bookId: bookId)
        let url = "\(baseURL)\(router.path)"
        return try await session.request(
            url,
            method: router.method,
            parameters: router.query,
            encoding: URLEncoding.default
        )
        .validate()
        .serializingDecodable(ChaptersWithBookAndAuthor.self)
        .value
    }
}
