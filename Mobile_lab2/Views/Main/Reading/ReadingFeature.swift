//
//  ReadingFeature.swift
//  Mobile_lab2
//
//  Created by dark type on 28.06.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ReadingFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        var book: BookUI
        var isFavorite: Bool
        var selectedChapter: Chapter? = nil
        var isChapterReadingPresented: Bool = false
        var currentChapterProgress: ReadingProgress? = nil

        init(book: BookUI, isFavorite: Bool = false) {
            self.book = book
            self.isFavorite = isFavorite
            if let firstChapter = book.chapters.first {
                self.currentChapterProgress = book.chapterProgresses[firstChapter.id]
            }
        }
        
        var currentChapter: Chapter? {
            guard !book.chapters.isEmpty else { return nil }
            let currentIndex = book.currentChapterIndex
            return book.chapters.indices.contains(currentIndex) ? book.chapters[currentIndex] : book.chapters.first
        }
        
        var hasChapters: Bool {
            !book.chapters.isEmpty
        }
    }

    // MARK: - Action

    enum Action: Equatable {
        case readButtonTapped
        case favoriteButtonTapped
        case chapterSelected(Chapter)
        case chapterReadingDismissed
        case currentBookIDStored
        case chapterProgressUpdated(chapterId: UUID, progress: Double)
        case loadChapterProgress(Chapter)

        case delegate(Delegate)

        enum Delegate: Equatable {
            case setCurrentBook(BookUI)
            case toggleFavorite(BookUI)
            case chapterProgressUpdated(BookUI)
        }
    }

    // MARK: - Dependencies

    @Dependency(\.userDefaultsService) var userDefaultsService

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .readButtonTapped:
                guard let currentChapter = state.currentChapter else {
                    return .none
                }
                
                state.selectedChapter = currentChapter
                state.isChapterReadingPresented = true
                state.currentChapterProgress = state.book.chapterProgresses[currentChapter.id]

                return .run { [book = state.book] send in
                    await userDefaultsService.setCurrentBookID(book.id)
                    await send(.currentBookIDStored)
                    await send(.delegate(.setCurrentBook(book)))
                }

            case .favoriteButtonTapped:
                state.isFavorite.toggle()
                var updatedBook = state.book
                updatedBook.isFavorite = state.isFavorite
                state.book = updatedBook
                
                return .send(.delegate(.toggleFavorite(state.book)))

            case let .chapterSelected(chapter):
                state.selectedChapter = chapter
                state.isChapterReadingPresented = true
                state.currentChapterProgress = state.book.chapterProgresses[chapter.id]

                return .run { [book = state.book] send in
                    await userDefaultsService.setCurrentBookID(book.id)
                    await send(.currentBookIDStored)
                    await send(.delegate(.setCurrentBook(book)))
                    await send(.loadChapterProgress(chapter))
                }

            case .chapterReadingDismissed:
                state.isChapterReadingPresented = false
                state.selectedChapter = nil
                state.currentChapterProgress = nil
                return .none

            case .currentBookIDStored:
                return .none
                
            case let .chapterProgressUpdated(chapterId, progress):
                state.book.updateChapterProgress(chapterId: chapterId, percentage: progress)
                
                if let selectedChapter = state.selectedChapter, selectedChapter.id == chapterId {
                    state.currentChapterProgress = state.book.chapterProgresses[chapterId]
                }
                
                return .send(.delegate(.chapterProgressUpdated(state.book)))
                
            case let .loadChapterProgress(chapter):
                state.currentChapterProgress = state.book.chapterProgresses[chapter.id]
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
