//
//  ChapterReadingFeature.swift
//  Mobile_lab2
//
//  Created by dark type on 28.06.2025.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ChapterReadingFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        var book: BookUI
        var currentChapter: Chapter

        var showChapters: Bool = false
        var showSettings: Bool = false
        var showQuoteOverlay: Bool = false

        var selectedText: String = ""
        var originalSelectedText: String = ""
        var isSelecting: Bool = false

        var savedParagraphIndex: Int = 0
        var savedSentenceIndex: Int = 0
        var readingProgress: ReadingProgress?

        var fontSize: CGFloat = 14
        var lineSpacing: CGFloat = 6

        var isReading: Bool = false
        var autoScrollEnabled: Bool = false
        var currentParagraphIndex: Int = 0
        var currentSentenceIndex: Int = 0
        var isScrollingProgrammatically: Bool = false
        var hasScrolled: Bool = false

        var shouldScrollToParagraph: Int? = nil
        var shouldAutoStartReading: Bool = false

        var highlightedTextCache: [String: String] = [:]
        var paragraphs: [String] {
            currentChapter.paragraphs
        }

        var cacheKeys: [String: String] {
            highlightedTextCache
        }

        init(book: BookUI, chapter: Chapter, shouldAutoStartReading: Bool = false) {
            self.book = book
            self.currentChapter = chapter
            self.shouldAutoStartReading = shouldAutoStartReading
        }
    }

    // MARK: - Action

    enum Action: Equatable {
        case viewAppeared
        case viewDisappeared

        case previousChapterTapped
        case nextChapterTapped
        case chapterSelected(Chapter)

        case toggleChaptersOverlay
        case toggleSettingsOverlay
        case toggleQuoteOverlay
        case closeAllOverlays

        case paragraphSelected(String)
        case selectedTextChanged(String)
        case restoreOriginalText
        case addQuote
        case cancelQuoteSelection

        case fontSizeIncreased
        case fontSizeDecreased
        case lineSpacingIncreased
        case lineSpacingDecreased

        case startReading(Int)
        case stopReading
        case readingTimerFired
        case scrollStateChanged(Bool)
        case paragraphIndexChanged(Int)
        case autoScrollToggled(Bool)
        case scrollToParagraph(Int)
        case setScrollingProgrammatically(Bool)

        case updateHighlightCache(key: String, highlighted: String)
        case highlightFirstSentence
        case advanceToNextSentence
        case moveToNextParagraph
        case readingCompleted

        case saveReadingProgress
        case loadReadingProgress(ReadingProgress?)
        case resetToSavedPosition
        case restartFromBeginning
    }

    // MARK: - Dependencies

    @Dependency(\.continuousClock) var clock

    // MARK: - Cancellation IDs

    private enum CancelID {
        case reading
        case sentenceTimer
    }

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewAppeared:
                let bookId = state.book.id
                let chapterId = state.currentChapter.id

                if state.shouldAutoStartReading {
                    state.shouldAutoStartReading = false
                    return .merge([
                        .run { _ in
                            // TODO: Load from API

                        },
                        .send(.startReading(0))
                    ])
                } else {
                    return .run { _ in
                        // TODO: Load from API
                    }
                }

            case .viewDisappeared:
                return .merge([
                    .send(.stopReading),
                    .cancel(id: CancelID.reading),
                    .cancel(id: CancelID.sentenceTimer)
                ])

            case .previousChapterTapped:
                if let currentIndex = state.book.chapters.firstIndex(where: { $0.id == state.currentChapter.id }) {
                    let previousIndex = currentIndex - 1
                    if previousIndex >= 0 {
                        state.isReading = false
                        state.autoScrollEnabled = false
                        state.currentChapter = state.book.chapters[previousIndex]
                        state.currentParagraphIndex = 0
                        state.currentSentenceIndex = 0
                        state.hasScrolled = false
                        return .cancel(id: CancelID.reading)
                    }
                }
                return .none

            case .nextChapterTapped:
                if let currentIndex = state.book.chapters.firstIndex(where: { $0.id == state.currentChapter.id }) {
                    let nextIndex = currentIndex + 1
                    if nextIndex < state.book.chapters.count {
                        state.isReading = false
                        state.autoScrollEnabled = false
                        state.currentChapter = state.book.chapters[nextIndex]
                        state.currentParagraphIndex = 0
                        state.currentSentenceIndex = 0
                        state.hasScrolled = false
                        return .cancel(id: CancelID.reading)
                    }
                }
                return .none

            case let .chapterSelected(chapter):
                state.showChapters = false
                state.currentChapter = chapter
                state.currentParagraphIndex = 0
                state.currentSentenceIndex = 0
                state.hasScrolled = false
                state.isReading = false
                state.autoScrollEnabled = false
                return .cancel(id: CancelID.reading)

            case .toggleChaptersOverlay:
                withAnimation {
                    state.showChapters.toggle()
                }
                return .none

            case .toggleSettingsOverlay:
                withAnimation {
                    state.showSettings.toggle()
                }
                return .none

            case .toggleQuoteOverlay:
                withAnimation {
                    state.showQuoteOverlay.toggle()
                }
                return .none

            case .closeAllOverlays:
                state.showChapters = false
                state.showSettings = false
                state.showQuoteOverlay = false
                return .none

            case let .paragraphSelected(paragraph):
                state.selectedText = paragraph
                state.originalSelectedText = paragraph
                state.showQuoteOverlay = true
                return .none

            case let .selectedTextChanged(text):
                if text.count <= state.originalSelectedText.count &&
                    state.originalSelectedText.contains(text) {
                    state.selectedText = text
                } else if text != state.originalSelectedText {
                    state.selectedText = state.originalSelectedText
                }
                return .none

            case .restoreOriginalText:
                state.selectedText = state.originalSelectedText
                return .none

            case .addQuote:
                // TODO: Implement quote saving functionality
                state.showQuoteOverlay = false
                state.selectedText = ""
                state.originalSelectedText = ""
                return .none

            case .cancelQuoteSelection:
                state.showQuoteOverlay = false
                state.selectedText = ""
                state.originalSelectedText = ""
                return .none

            case .fontSizeIncreased:
                if state.fontSize < 24 {
                    state.fontSize += 2
                }
                return .none

            case .fontSizeDecreased:
                if state.fontSize > 14 {
                    state.fontSize -= 2
                }
                return .none

            case .lineSpacingIncreased:
                if state.lineSpacing < 12 {
                    state.lineSpacing += 2
                }
                return .none

            case .lineSpacingDecreased:
                if state.lineSpacing > 4 {
                    state.lineSpacing -= 2
                }
                return .none

            case let .updateHighlightCache(key, highlighted):
                state.highlightedTextCache[key] = highlighted
                return .none

            case let .startReading(index):

                if index == state.currentParagraphIndex && (state.savedParagraphIndex != 0 || state.savedSentenceIndex != 0) {
                    state.currentParagraphIndex = state.savedParagraphIndex
                    state.currentSentenceIndex = state.savedSentenceIndex
                } else {
                    state.currentParagraphIndex = index
                    state.currentSentenceIndex = 0
                    state.savedParagraphIndex = index
                    state.savedSentenceIndex = 0
                }

                state.isReading = true
                state.autoScrollEnabled = true

                return .merge([
                    .send(.scrollToParagraph(state.currentParagraphIndex)),
                    .run { send in
                        try await clock.sleep(for: .milliseconds(800))
                        await send(.highlightFirstSentence)
                    }
                    .cancellable(id: CancelID.reading, cancelInFlight: true)
                ])

            case .highlightFirstSentence:
                state.currentSentenceIndex = 0
                return .run { send in
                    try await clock.sleep(for: .milliseconds(500))
                    await send(.advanceToNextSentence)
                }

            case let .scrollToParagraph(index):
                state.shouldScrollToParagraph = index
                state.isScrollingProgrammatically = true
                return .none

            case let .setScrollingProgrammatically(isScrolling):
                state.isScrollingProgrammatically = isScrolling
                state.shouldScrollToParagraph = nil
                return .none

            case let .scrollStateChanged(hasScrolled):
                withAnimation(.easeOut(duration: 0.2)) {
                    state.hasScrolled = hasScrolled
                }
                if hasScrolled && state.isReading && state.autoScrollEnabled && !state.isScrollingProgrammatically {
                    state.autoScrollEnabled = false
                }
                return .none

            case .stopReading:
                state.isReading = false
                state.autoScrollEnabled = false
                state.savedParagraphIndex = state.currentParagraphIndex
                state.savedSentenceIndex = state.currentSentenceIndex
                return .merge([
                    .cancel(id: CancelID.reading),
                    .send(.saveReadingProgress)
                ])

            case let .paragraphIndexChanged(index):
                state.currentParagraphIndex = index
                return .none

            case let .autoScrollToggled(enabled):
                state.autoScrollEnabled = enabled
                return .none

            case .advanceToNextSentence:
                guard state.isReading, state.currentParagraphIndex < state.paragraphs.count else {
                    return .send(.readingCompleted)
                }

                let paragraph = state.paragraphs[state.currentParagraphIndex]
                let sentences = TextProcessingUtils.splitIntoSentences(paragraph)

                if state.currentSentenceIndex >= sentences.count {
                    return .send(.moveToNextParagraph)
                }

                let sentence = sentences[state.currentSentenceIndex]
                let readingTime = TextProcessingUtils.calculateReadingTime(for: sentence)

                state.currentSentenceIndex += 1
                state.savedParagraphIndex = state.currentParagraphIndex
                state.savedSentenceIndex = state.currentSentenceIndex

                return .merge([
                    .run { send in
                        try await clock.sleep(for: .seconds(readingTime))
                        try await clock.sleep(for: .milliseconds(100))
                        await send(.advanceToNextSentence)
                    }
                    .cancellable(id: CancelID.sentenceTimer, cancelInFlight: true),
                    .send(.saveReadingProgress)
                ])

            case .moveToNextParagraph:
                if state.currentParagraphIndex + 1 < state.paragraphs.count {
                    state.currentParagraphIndex += 1
                    state.currentSentenceIndex = 0
                    state.savedParagraphIndex = state.currentParagraphIndex
                    state.savedSentenceIndex = 0

                    let effects: [Effect<Action>] = [
                        .run { send in
                            try await clock.sleep(for: .milliseconds(200))
                            await send(.advanceToNextSentence)
                        },
                        .send(.saveReadingProgress)
                    ]

                    if state.autoScrollEnabled {
                        return .merge(effects + [.send(.scrollToParagraph(state.currentParagraphIndex))])
                    }

                    return .merge(effects)
                } else {
                    return .send(.readingCompleted)
                }

            case .readingCompleted:
                state.isReading = false
                state.autoScrollEnabled = false
                state.savedParagraphIndex = state.paragraphs.count
                state.savedSentenceIndex = 0
                return .merge([
                    .cancel(id: CancelID.reading),
                    .send(.saveReadingProgress)
                ])

            case .saveReadingProgress:

                let progress = ReadingProgressCalculator.createReadingProgress(from: state)
                state.readingProgress = progress

                return .run { [progress] _ in
                    // TODO: Save to API
                    print("📖 Saving progress: P\(progress.paragraphIndex) S\(progress.sentenceIndex) (\(Int(progress.progressPercentage * 100))%)")
                }

            case let .loadReadingProgress(progress):
                if let progress = progress {
                    state.readingProgress = progress
                    state.savedParagraphIndex = progress.paragraphIndex
                    state.savedSentenceIndex = progress.sentenceIndex
                    state.currentParagraphIndex = progress.paragraphIndex
                    state.currentSentenceIndex = progress.sentenceIndex
                }
                return .none

            case .resetToSavedPosition:
                state.currentParagraphIndex = state.savedParagraphIndex
                state.currentSentenceIndex = state.savedSentenceIndex
                return .none

            case .restartFromBeginning:
                state.currentParagraphIndex = 0
                state.currentSentenceIndex = 0
                state.savedParagraphIndex = 0
                state.savedSentenceIndex = 0
                return .send(.saveReadingProgress)

            case .readingTimerFired:
                return .none
            }
        }
    }
}
