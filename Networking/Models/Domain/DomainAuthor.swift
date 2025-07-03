import Foundation

public struct DomainAuthor: Identifiable, Equatable, Codable {
    public let id: String
    public let name: String
    public let avatarURL: String
    
    public init(id: String, name: String, avatarURL: String = "") {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
    }
}