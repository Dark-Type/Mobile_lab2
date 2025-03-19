//
//  MockData.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import Foundation

enum MockData {
    static let sampleChapterContent = """
    Париж, Лувр 21.46
    Знаменитый куратор Жак Соньер, пошатываясь, прошел под сводчатой аркой Большой галереи и устремился к первой попавшейся ему
    на глаза картине, полотну Караваджо. Ухватился руками за позолоченную раму и стал тянуть
    ее на себя, пока шедевр не сорвался со стены и
    не рухнул на семидесятилетнего старика Соньера, погребя его под собой.
    Как и предполагал Соньер, неподалеку с грохотом опустилась металлическая решетка, преграждающая доступ в этот зал. Паркетный пол содрогнулся. Где-то завыла сирена сигнализации.Несколько секунд куратор лежал неподвижно, хватая ртом воздух и пытаясь сообразить, на каком свете находится. Я все еще жив. Потом он выполз из-под полотна
    и начал судорожно озираться в поисках места, где можно спрятаться.
    Голос прозвучал неожиданно близко: — Не двигаться. Стоявший на четвереньках куратор похолодел,
    потом медленно обернулся. Всего в пятнадцати футах от него, за решеткой, высилась внушительная и грозная фигура его преследователя. Высокий, широкоплечий, с мертвенно-бледной кожей и редкими
    белыми волосами. Белки розовые, а зрачки угрожающего темнокрасного цвета. Альбинос достал из кармана пистолет, сунул
    длинный ствол в отверстие между железными прутьями и прицелился в куратора.
    """
    

    static func createSampleChapters(count: Int) -> [Chapter] {
        var chapters: [Chapter] = []
        
        chapters.append(Chapter(
            title: "Prologue",
            number: 0,
            content: sampleChapterContent,
            isStarted: true,
            isFinished: true
        ))
        
        for i in 1 ... count {
            chapters.append(Chapter(
                title: "Chapter \(i)",
                number: i,
                content: sampleChapterContent,
                isStarted: i < 3,
                isFinished: i < 2
            ))
        }
        
        return chapters
    }
    
    static let books: [Book] = [
        Book(
            title: "Код да Винчи",
            author: [Author("Дэн Браун", MockBooks.book1.image)],
            description: "Секретный код скрыт в работах Леонардо да Винчи... Только он поможет найти христианские святыни, дающие немыслимые власть и могущество... Ключ к величайшей тайне, над которой человечество билось веками, наконец может быть найден...",
            coverImage: MockBooks.book1.image,
            posterImage: MockBooks.book1.image,
            genres: ["Mystery", "Thriller"],
            chapters: createSampleChapters(count: 15),
            userProgress: ReadingProgress(
                bookId: UUID(),
                currentChapter: 0,
                currentPosition: 0.3,
                overallProgress: 0.1,
                lastReadDate: Date()
            ),
            isFavorite: true
        ),
        Book(
            title: "Stellar Horizons",
            author: [Author("Marcus Webb", MockBooks.book1.image)],
            description: "An epic space adventure following the crew of the starship Horizon as they venture into uncharted territories of the galaxy.",
            coverImage: MockBooks.book1.image,
            posterImage: MockBooks.book1.image,
            genres: ["Science Fiction", "Adventure"],
            chapters: createSampleChapters(count: 12)
        ),
        Book(
            title: "The Hidden Garden",
            author: [Author("Eleanor Hughes", MockBooks.book1.image)],
            description: "A magical tale about a young girl who discovers a garden with mysterious powers that change with the seasons.",
            coverImage: MockBooks.book1.image,
            posterImage: MockBooks.book1.image,
            genres: ["Fantasy", "Young Adult"],
            chapters: createSampleChapters(count: 18),
            isFavorite: true
        ),
        Book(
            title: "Midnight Chronicles",
            author: [Author("Jonathan Blake", MockBooks.book1.image)],
            description: "Dark fantasy epic set in a world where night lasts for months and dangerous creatures roam the shadows.",
            coverImage: MockBooks.book1.image,
            posterImage: MockBooks.book1.image,
            genres: ["Fantasy", "Horror"],
            chapters: createSampleChapters(count: 20)
        ),
        Book(
            title: "The Last Summer",
            author: [Author("Sarah Chen", MockBooks.book1.image)],
            description: "A touching coming-of-age story about friendship, love, and saying goodbye set during one unforgettable summer.",
            coverImage: MockBooks.book1.image,
            posterImage: MockBooks.book1.image,
            genres: ["Contemporary", "Romance"],
            chapters: createSampleChapters(count: 14),
            userProgress: ReadingProgress(
                bookId: UUID(),
                currentChapter: 4,
                currentPosition: 0.6,
                overallProgress: 0.33,
                lastReadDate: Date().addingTimeInterval(-86400)
            )
        ),
        Book(
            title: "Whispers of the Past",
            author: [Author("Thomas Wilson", MockBooks.book1.image)],
            description: "Historical fiction following multiple generations of a family through pivotal moments in history.",
            coverImage: MockBooks.book1.image,
            posterImage: MockBooks.book1.image,
            genres: ["Historical Fiction", "Drama"],
            chapters: createSampleChapters(count: 22),
            userProgress: ReadingProgress(
                bookId: UUID(),
                currentChapter: 1,
                currentPosition: 0.1,
                overallProgress: 0.05,
                lastReadDate: Date().addingTimeInterval(-172800)
            )
        )
    ]
    
    static let quotes: [Quote] = [
        Quote(
            content: "Я все еще жив",
            bookId: books[0].id,
            bookTitle: books[0].title,
            author: books[0].author
        ),
        Quote(
            content: "Memory is a tricky thing - it doesn't record the world as it is, but as we are.",
            bookId: books[0].id,
            bookTitle: books[0].title,
            author: books[0].author
        ),
        Quote(
            content: "She stepped into the garden and felt time itself slow down around her, as if the flowers were drinking it up like sunlight.",
            bookId: books[2].id,
            bookTitle: books[2].title,
            author: books[2].author
        )
    ]
    
    static let genres = ["Adventure", "Biography", "Contemporary", "Fantasy", "Historical Fiction", "Horror", "Mystery", "Romance", "Science Fiction", "Thriller", "Young Adult"]
    
    static let authors = [Author("Дэн Браун", MockBooks.book1.image), Author("Marcus Webb", MockBooks.book1.image), Author("Eleanor Hughes", MockBooks.book1.image), Author("Jonathan Blake", MockBooks.book1.image), Author("Sarah Chen", MockBooks.book1.image), Author("Thomas Wilson", MockBooks.book1.image) ]
}
