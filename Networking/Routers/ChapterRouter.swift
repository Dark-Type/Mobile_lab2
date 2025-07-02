//
//  ChapterRouter.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

enum ChapterRouter {
    case getBookByChapterId(chapterId: Int)
    case getChapterByBookId(bookId: Int)

    var method: String { "GET" }
    var path: String { "/api/chapters" }

    var query: [String: Any] {
        switch self {
        case let .getBookByChapterId(chapterId):
            return [
                "filters[id][$eq]": chapterId,
                "populate[book][populate][authors][fields][0]": "id",
                "populate[book][populate][authors][fields][1]": "name",
                "populate[book][populate][authors][fields][2]": "avatarURL"
            ]
        case let .getChapterByBookId(bookId):
            return [
                "filters[book][id][$eq]": bookId,
                "populate[book][populate][authors][fields][0]": "id",
                "populate[book][populate][authors][fields][1]": "name",
                "populate[book][populate][authors][fields][2]": "avatarURL"
            ]
        }
    }
}
