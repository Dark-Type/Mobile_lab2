//
//  ProgressRouter.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

import Alamofire

enum ProgressRouter {
    case getProgresses
    case saveProgress
    case updateProgress(progressId: String)

    var method: HTTPMethod {
        switch self {
        case .getProgresses: return .get
        case .saveProgress: return .post
        case .updateProgress: return .put
        }
    }

    var path: String {
        switch self {
        case .getProgresses, .saveProgress: return "/api/progresses"
        case .updateProgress(let progressId): return "/api/progresses/\(progressId)"
        }
    }
}
