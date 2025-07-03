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

        init(book: BookUI, isFavorite: Bool = false) {
            self.book = book
            self.isFavorite = isFavorite
        }
    }

    // MARK: - Action

    enum Action: Equatable {
        case readButtonTapped
        case favoriteButtonTapped
        case chapterSelected(Chapter)
        case chapterReadingDismissed
        case currentBookIDStored

        case delegate(Delegate)

        enum Delegate: Equatable {
            case setCurrentBook(BookUI)
            case toggleFavorite(BookUI)
        }
    }

    // MARK: - Dependencies

    @Dependency(\.userDefaultsService) var userDefaultsService

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .readButtonTapped:
                let chapter = state.book.chapters[state.book.userProgress.currentChapter]
                state.selectedChapter = chapter
                state.isChapterReadingPresented = true

                return .run { [book = state.book] send in
                    await userDefaultsService.setCurrentBookID(book.id)
                    await send(.currentBookIDStored)
                    await send(.delegate(.setCurrentBook(book)))
                }

            case .favoriteButtonTapped:
                return .send(.delegate(.toggleFavorite(state.book)))

            case let .chapterSelected(chapter):
                state.selectedChapter = chapter
                state.isChapterReadingPresented = true

                return .run { [book = state.book] send in
                    await userDefaultsService.setCurrentBookID(book.id)
                    await send(.currentBookIDStored)
                    await send(.delegate(.setCurrentBook(book)))
                }

            case .chapterReadingDismissed:
                state.isChapterReadingPresented = false
                state.selectedChapter = nil
                return .none

            case .currentBookIDStored:
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
