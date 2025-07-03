import Foundation

public struct DomainProgresses: Codable {
    public let progresses: [DomainProgress]
    
    public init(progresses: [DomainProgress]) {
        self.progresses = progresses
    }
}

public struct DomainProgress: Identifiable, Codable {
    public let id: String
    public let value: Double
    public let chapterId: String
    public let createdAt: String
    public let updatedAt: String
    
    public init(id: String, value: Double, chapterId: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.value = value
        self.chapterId = chapterId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct DomainShortProgress: Codable {
    public let value: Double
    public let chapterId: String
    
    public init(value: Double, chapterId: String) {
        self.value = value
        self.chapterId = chapterId
    }
}