//
//  ChapterReadingView.swift
//  Mobile_lab2
//
//  Created by dark type on 19.03.2025.
//

import SwiftUI

struct ChapterReadingView: View {
    // MARK: - Properties

    let book: Book
    let setCurrentBook: (Book) -> Void
    @State private var currentChapter: Chapter
    @Environment(\.dismiss) private var dismiss

    @State private var showChapters: Bool = false
    @State private var showSettings: Bool = false
    @State private var showQuoteOverlay: Bool = false
    @State private var selectedText: String = ""
    @State private var originalSelectedText: String = ""
    @State private var alertMessage = ""

    @State private var isSelecting: Bool = false
    @State private var selectionTimer: Timer?

    @State private var fontSize: CGFloat = 14
    @State private var lineSpacing: CGFloat = 6

    @State private var isReading: Bool = false
    @State private var autoScrollEnabled: Bool = false
    @State private var currentParagraphIndex: Int = 0
    @State private var currentSentenceIndex: Int = 0
    @State private var isScrollingProgrammatically: Bool = false
    @State private var readingWorkItem: DispatchWorkItem? = nil
    private var paragraphs: [String] {
        currentChapter.paragraphs
    }

    @State private var hasScrolled: Bool = false

    init(book: Book, setCurrentBook: @escaping (Book) -> Void, chapter: Chapter) {
        self.book = book
        self.setCurrentBook = setCurrentBook
        _currentChapter = State(initialValue: chapter)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(AppColors.background.color)
                        .frame(height: 1)
                        .offset(y: -1)
                        .zIndex(1)
                    ScrollView(showsIndicators: false) {
                        VisibilityDetector(onVisible: {
                            withAnimation(.easeOut(duration: 0.2)) {
                                hasScrolled = false
                            }
                        })
                        .frame(height: 1)
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(Array(paragraphs.enumerated()), id: \.offset) { index, paragraph in
                                ParagraphView(
                                    paragraph: paragraph,
                                    index: index,
                                    isCurrentParagraph: index == currentParagraphIndex && isReading,
                                    currentSentenceIndex: currentSentenceIndex,
                                    fontSize: fontSize,
                                    lineSpacing: lineSpacing,
                                    onSelect: selectWholeParagraph
                                )
                            }
                        }
                        .padding(.top, 24)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 120)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.chapterReadingView.rawValue)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 5)
                            .onChanged { value in
                                if value.translation.height < -20 {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        hasScrolled = true
                                    }
                                }
                                if isReading, autoScrollEnabled, !isScrollingProgrammatically {
                                    autoScrollEnabled = false
                                }
                            }
                    )
                }
                .onChange(of: currentParagraphIndex) { newIndex in
                    guard newIndex < paragraphs.count, isReading, autoScrollEnabled else { return }

                    isScrollingProgrammatically = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            proxy.scrollTo("para-\(newIndex)", anchor: .center)
                            hasScrolled = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isScrollingProgrammatically = false
                        }
                    }
                }
                .onChange(of: currentChapter) { _ in
                    proxy.scrollTo("para-0", anchor: .top)
                }
            }

            VStack(spacing: 0) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: AppColors.background.color, location: 0),
                                .init(color: AppColors.background.color.opacity(0), location: 1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 60)
                    .opacity(hasScrolled ? 1 : 0)
                Spacer()
            }
            .allowsHitTesting(false)
            .frame(maxHeight: .infinity, alignment: .top)

            VStack(spacing: 0) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: AppColors.background.color.opacity(0), location: 0),
                                .init(color: AppColors.background.color, location: 1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 100)
                    .allowsHitTesting(false)

                ChapterTabBar(
                    book: book,
                    currentChapter: $currentChapter,
                    showChapters: $showChapters,
                    showSettings: $showSettings,
                    isReading: $isReading,
                    autoScrollEnabled: $autoScrollEnabled,
                    currentParagraphIndex: $currentParagraphIndex,
                    onStartReading: { index in
                        startReading(at: index, proxy: nil)
                    }
                )
            }
            .ignoresSafeArea(.all, edges: .bottom)

            if showChapters {
                ChaptersOverlayView(book: book, currentChapter: $currentChapter, showChapters: $showChapters)
            }

            if showSettings {
                SettingsOverlayView(fontSize: $fontSize, lineSpacing: $lineSpacing, showSettings: $showSettings)
            }

            if showQuoteOverlay {
                QuoteSelectionOverlayView(selectedText: $selectedText, originalSelectedText: $originalSelectedText, showQuoteOverlay: $showQuoteOverlay)
            }
        }
        .onAppear {
            setCurrentBook(book)
        }
        .onDisappear {
            stopReading()
            cleanupSelectionResources()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            LeadingToolbarItem(dismiss: { dismiss() })
            PrincipalToolbarItem(book: book, currentChapter: currentChapter)
        }
        .onChange(of: currentChapter) { _ in
            currentParagraphIndex = 0
            currentSentenceIndex = 0
            hasScrolled = false
        }
        .background(
            AppColors.background.color
                .ignoresSafeArea()
        )
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar(showChapters || showSettings || showQuoteOverlay ? .hidden : .automatic, for: .navigationBar)
    }

    private func cleanupSelectionResources() {
        selectionTimer?.invalidate()
        selectionTimer = nil
        isSelecting = false
    }

    // MARK: - Text Selection Methods

    private func selectWholeParagraph(_ paragraph: String) {
        selectedText = paragraph
        withAnimation(.spring()) {
            showQuoteOverlay = true
        }
    }

    // MARK: - Reading Control Methods

    private func startReading(at index: Int, proxy: ScrollViewProxy?) {
        readingWorkItem?.cancel()
        readingWorkItem = nil
        currentParagraphIndex = index
        currentSentenceIndex = 0
        isReading = true
        autoScrollEnabled = true
        if let proxy = proxy {
            isScrollingProgrammatically = true
            withAnimation {
                proxy.scrollTo("para-\(index)", anchor: .center)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isScrollingProgrammatically = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            advanceToNextSentence()
        }
    }

    private func stopReading() {
        isReading = false
        autoScrollEnabled = false
        readingWorkItem?.cancel()
        readingWorkItem = nil
    }

    private func advanceToNextSentence() {
        readingWorkItem?.cancel()
        guard isReading, currentParagraphIndex < paragraphs.count else {
            if currentParagraphIndex >= paragraphs.count {
                stopReading()
            }
            return
        }
        let paragraph = paragraphs[currentParagraphIndex]
        let sentences = TextProcessingUtils.splitIntoSentences(paragraph)
        if currentSentenceIndex >= sentences.count {
            if currentParagraphIndex + 1 < paragraphs.count {
                currentParagraphIndex += 1
                currentSentenceIndex = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    advanceToNextSentence()
                }
            } else {
                stopReading()
            }
            return
        }
        let sentence = sentences[currentSentenceIndex]
        let readingTime = TextProcessingUtils.calculateReadingTime(for: sentence)
        let workItem = DispatchWorkItem {
            guard isReading else { return }
            DispatchQueue.main.async {
                currentSentenceIndex += 1

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    advanceToNextSentence()
                }
            }
        }
        readingWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + readingTime, execute: workItem)
    }
}

#Preview {
    NavigationStack {
        ChapterReadingView(
            book: MockData.books[0],
            setCurrentBook: { _ in },
            chapter: MockData.books[0].chapters[1]
        )
    }
}
