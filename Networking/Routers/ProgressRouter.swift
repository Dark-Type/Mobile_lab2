//
//  ProgressRouter.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

enum ProgressRouter {
    case getProgresses
    case saveProgress
    case updateProgress(progressId: String)

    var method: String {
        switch self {
        case .getProgresses: return "GET"
        case .saveProgress: return "POST"
        case .updateProgress: return "PUT"
        }
    }

    var path: String {
        switch self {
        case .getProgresses, .saveProgress: return "/api/progresses"
        case .updateProgress(let progressId): return "/api/progresses/\(progressId)"
        }
    }
}
