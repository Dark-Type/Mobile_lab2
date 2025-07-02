//
//  ProgressRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

protocol ProgressRepositoryProtocol: Sendable {
    func getProgresses() async throws -> Progresses
    func saveProgress(_ progress: ShortProgress) async throws -> Progress
    func updateProgress(progressId: String, progress: ShortProgress) async throws -> Progress
}

final class ProgressRepository: ProgressRepositoryProtocol {
    private let service: ProgressServiceProtocol

    init(service: ProgressServiceProtocol) {
        self.service = service
    }

    func getProgresses() async throws -> Progresses {
        try await service.getProgresses()
    }

    func saveProgress(_ progress: ShortProgress) async throws -> Progress {
        try await service.saveProgress(progress)
    }

    func updateProgress(progressId: String, progress: ShortProgress) async throws -> Progress {
        try await service.updateProgress(progressId: progressId, progress: progress)
    }
}
