//
//  ProgressService.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

internal import Alamofire
import Foundation

protocol ProgressServiceProtocol: Sendable {
    func getProgresses() async throws -> Progresses
    func saveProgress(_ progress: ShortProgress) async throws -> Progress
    func updateProgress(progressId: String, progress: ShortProgress) async throws -> Progress
}

final class ProgressService: ProgressServiceProtocol {
    private let session: Session
    private let baseURL: String

    init(session: Session = .shared, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    func getProgresses() async throws -> Progresses {
        let url = "\(baseURL)\(ProgressRouter.getProgresses.path)"
        return try await session.request(
            url,
            method: ProgressRouter.getProgresses.method
        )
        .validate()
        .serializingDecodable(Progresses.self)
        .value
    }

    func saveProgress(_ progress: ShortProgress) async throws -> Progress {
        let url = "\(baseURL)\(ProgressRouter.saveProgress.path)"
        let saveProgress = SaveProgress(data: progress)
        return try await session.request(
            url,
            method: ProgressRouter.saveProgress.method,
            parameters: saveProgress,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingDecodable(Progress.self)
        .value
    }

    func updateProgress(progressId: String, progress: ShortProgress) async throws -> Progress {
        let url = "\(baseURL)\(ProgressRouter.updateProgress(progressId: progressId).path)"
        let saveProgress = SaveProgress(data: progress)
        return try await session.request(
            url,
            method: ProgressRouter.updateProgress(progressId: progressId).method,
            parameters: saveProgress,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingDecodable(Progress.self)
        .value
    }
}
