
public struct DomainGenres: Codable {
    public let genres: [DomainGenre]
    
    public init(genres: [DomainGenre]) {
        self.genres = genres
    }
}

public struct DomainGenre: Identifiable, Codable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

public struct DomainAuthors: Codable {
    public let authors: [DomainAuthor]
    
    public init(authors: [DomainAuthor]) {
        self.authors = authors
    }
}