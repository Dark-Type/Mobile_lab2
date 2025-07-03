//
//  ProgressRepository.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

public protocol ProgressRepositoryProtocol: Sendable {
    func getProgresses() async throws -> DomainProgresses
    func saveProgress(_ progress: DomainShortProgress) async throws -> DomainProgress
    func updateProgress(progressId: String, progress: DomainShortProgress) async throws -> DomainProgress
}

public final class ProgressRepository: ProgressRepositoryProtocol {
    private let service: ProgressServiceProtocol

    public init(service: ProgressServiceProtocol) {
        self.service = service
    }

    public func getProgresses() async throws -> DomainProgresses {
        let networkData = try await service.getProgresses()
        return networkData.toDomainProgresses()
    }

    public func saveProgress(_ progress: DomainShortProgress) async throws -> DomainProgress {
        let networkProgress = progress.toShortProgress()
        let networkData = try await service.saveProgress(networkProgress)
        return networkData.toDomainProgress()
    }

    public func updateProgress(progressId: String, progress: DomainShortProgress) async throws -> DomainProgress {
        let networkProgress = progress.toShortProgress()
        let networkData = try await service.updateProgress(progressId: progressId, progress: networkProgress)
        return networkData.toDomainProgress()
    }
}
