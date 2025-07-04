//
//  MockData.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import Foundation

enum MockData {
    static var isEmptyStateTest: Bool {
        ProcessInfo.processInfo.arguments.contains("-empty-state-test")
    }

    static var isTestMode: Bool {
        ProcessInfo.processInfo.arguments.contains("-UITestMode")
    }

    static let sampleChapterContent = isEmptyStateTest ? "" : """
    Париж, Лувр 21.46
    Знаменитый куратор Жак Соньер, пошатываясь, прошел под сводчатой аркой Большой галереи и устремился к первой попавшейся ему на глаза картине, полотну Караваджо. Ухватился руками за позолоченную раму и стал тянуть ее на себя, пока шедевр не сорвался со стены и не рухнул на семидесятилетнего старика Соньера, погребя его под собой.\nКак и предполагал Соньер, неподалеку с грохотом опустилась металлическая решетка, преграждающая доступ в этот зал. Паркетный пол содрогнулся. Где-то завыла сирена сигнализации.\nНесколько секунд куратор лежал неподвижно, хватая ртом воздух и пытаясь сообразить, на каком свете находится. Я все еще жив. Потом он выполз из-под полотна и начал судорожно озираться в поисках места, где можно спрятаться.\n Голос прозвучал неожиданно близко:\n — Не двигаться.\n Стоявший на четвереньках куратор похолодел, потом медленно обернулся. Всего в пятнадцати футах от него, за решеткой, высилась внушительная и грозная фигура его преследователя. Высокий, широкоплечий, с мертвенно-бледной кожей и редкими белыми волосами. Белки розовые, а зрачки угрожающего темнокрасного цвета. Альбинос достал из кармана пистолет, сунул длинный ствол в отверстие между железными прутьями и прицелился в куратора.\n— Ты не должен бежать, — произнес он с трудно определимым акцентом. — А теперь говори: где оно?\n— Но я ведь уже сказал, — запинаясь пробормотал куратор, по-прежнему беспомощно стоявший на четвереньках. — Понятия не имею, о чем вы говорите.\n— Ложь! — Мужчина был неподвижен и смотрел на него немигающим взором страшных глаз, в которых поблескивали красные искорки. — У тебя и твоих братьев есть кое-что, принадлежащее отнюдь не вам. Куратор содрогнулся. Откуда он может знать?\n— И сегодня этот предмет обретет своих настоящих владельцев. Так что скажи, где он, и останешься жив. — Мужчина опустил ствол чуть ниже, теперь он был направлен прямо в голову куратора. — Или это тайна, ради которой ты готов умереть?
    """

    static func createSampleChapters(count: Int) -> [Chapter] {
        var chapters: [Chapter] = []

        chapters.append(Chapter(
            title: "Факты",
            number: 0,
            content: sampleChapterContent,
            isStarted: true,
            isFinished: true
        ))

        chapters.append(Chapter(
            title: "Пролог",
            number: 1,
            content: sampleChapterContent,
            isStarted: true,
            isFinished: true
        ))

        for i in 2 ... count {
            chapters.append(Chapter(
                title: "Глава \(i - 1)",
                number: i,
                content: sampleChapterContent,
                isStarted: i < 3,
                isFinished: i < 2
            ))
        }
        return chapters
    }

    static let books: [BookUI] = isEmptyStateTest ? [] : [
        BookUI(
            title: "Код да Винчи",
            author: [Author("Дэн Браун", MockBooks.book1.image)],
            description: "Секретный код скрыт в работах Леонардо да Винчи...\nТолько он поможет найти христианские святыни, дающие немыслимые власть и могущество...\nКлюч к величайшей тайне, над которой человечество билось веками, наконец может быть найден...",
            coverImage: MockBooks.book1.image,
            posterImage: MockPosters.poster1.image,
            genres: ["Mystery", "Thriller"],
            chapters: createSampleChapters(count: 15),
            userProgress: ReadingProgress(
                bookId: UUID().uuidString,
                totalChapters: 15,
                currentChapter: 0,
                currentPosition: 0.3
            ),
            isFavorite: false
        ),
        BookUI(
            title: "Stellar Horizons",
            author: [Author("Marcus Webb", MockBooks.book1.image)],
            description: "An epic space adventure following the crew of the starship Horizon as they venture into uncharted territories of the galaxy.",
            coverImage: MockBooks.book1.image,
            posterImage: MockPosters.poster4.image,
            genres: ["Science Fiction", "Adventure"],
            chapters: createSampleChapters(count: 12)
        ),
        BookUI(
            title: "The Hidden Garden",
            author: [Author("Eleanor Hughes", MockBooks.book1.image)],
            description: "A magical tale about a young girl who discovers a garden with mysterious powers that change with the seasons.",
            coverImage: MockBooks.book1.image,
            posterImage: MockPosters.poster4.image,
            genres: ["Fantasy", "Young Adult"],
            chapters: createSampleChapters(count: 18),
            isFavorite: false
        ),
        BookUI(
            title: "Swift. Карманный справочник: программирование в среде iOS и ОS X",
            author: [Author("Jonathan Blake", MockBooks.book1.image)],
            description: "Dark fantasy epic set in a world where night lasts for months and dangerous creatures roam the shadows.",
            coverImage: MockBooks.book1.image,
            posterImage: MockPosters.poster4.image,
            genres: ["Fantasy", "Horror"],
            chapters: createSampleChapters(count: 20)
        ),
        BookUI(
            title: "The Last Summer",
            author: [Author("Sarah Chen", MockBooks.book1.image)],
            description: "A touching coming-of-age story about friendship, love, and saying goodbye set during one unforgettable summer.",
            coverImage: MockBooks.book1.image,
            posterImage: MockPosters.poster4.image,
            genres: ["Contemporary", "Romance"],
            chapters: createSampleChapters(count: 14)
        ),
        BookUI(
            title: "Whispers of the Past",
            author: [Author("Thomas Wilson", MockBooks.book1.image)],
            description: "Historical fiction following multiple generations of a family through pivotal moments in history.",
            coverImage: MockBooks.book1.image,
            posterImage: MockPosters.poster4.image,
            genres: ["Historical Fiction", "Drama"],
            chapters: createSampleChapters(count: 22)
        )
    ]
    static let quotes: [Quote] = isEmptyStateTest ? [] : [
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
    static var testCurrentBook: BookUI? {
        if isTestMode, !isEmptyStateTest {
            return books.first
        }
        return nil
    }

    static var testFavoriteBooks: [BookUI]? {
        if isTestMode, !isEmptyStateTest {
            return [books[1], books[2]]
        }
        return []
    }

    static let genres = isEmptyStateTest ? [] : ["Классика", "Фэнтези", "Фантастика", "Детектив", "Триллер", "Исторический роман", "Любовный роман", "Приключения", "Поэзия", "Биография", "Для детей", "Для подростков"]
    static let authors = isEmptyStateTest ? [] : [Author("Дэн Браун", MockBooks.book1.image), Author("Marcus Webb", MockBooks.book1.image), Author("Eleanor Hughes", MockBooks.book1.image), Author("Jonathan Blake", MockBooks.book1.image), Author("Sarah Chen", MockBooks.book1.image), Author("Thomas Wilson", MockBooks.book1.image)]
}
