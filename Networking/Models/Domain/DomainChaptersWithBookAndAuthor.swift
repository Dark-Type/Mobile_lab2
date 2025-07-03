public struct DomainChaptersWithBookAndAuthor: Codable {
    public let chapters: [DomainChapterWithBook]
    
    public init(chapters: [DomainChapterWithBook]) {
        self.chapters = chapters
    }
}

public struct DomainChapterWithBook: Identifiable, Codable {
    public let id: String
    public let title: String
    public let number: Int
    public let content: String
    public let book: DomainBook
    
    public init(id: String, title: String, number: Int, content: String, book: DomainBook) {
        self.id = id
        self.title = title
        self.number = number
        self.content = content
        self.book = book
    }
}