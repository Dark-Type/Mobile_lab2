//
//  ProgressRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

public protocol ProgressRepositoryProtocol: Sendable {
    func getProgresses() async throws -> Progresses
    func saveProgress(_ progress: ShortProgress) async throws -> Progress
    func updateProgress(progressId: String, progress: ShortProgress) async throws -> Progress
}

public final class ProgressRepository: ProgressRepositoryProtocol {
    private let service: ProgressServiceProtocol

    public init(service: ProgressServiceProtocol) {
        self.service = service
    }

    public func getProgresses() async throws -> Progresses {
        try await service.getProgresses()
    }

    public func saveProgress(_ progress: ShortProgress) async throws -> Progress {
        try await service.saveProgress(progress)
    }

    public func updateProgress(progressId: String, progress: ShortProgress) async throws -> Progress {
        try await service.updateProgress(progressId: progressId, progress: progress)
    }
}
