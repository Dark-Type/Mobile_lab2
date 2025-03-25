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
                                paragraphView(paragraph, index: index, proxy: proxy)
                                    .id("para-\(index)")
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
                chapterTabBar
            }
            .ignoresSafeArea(.all, edges: .bottom)
            
            if showChapters { chaptersOverlay }
            if showSettings { settingsOverlay }
            if showQuoteOverlay { quoteSelectionOverlay }
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
            leadingToolbarItem
            principalToolbarItem
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
}

struct VisibilityDetector: View {
    let onVisible: () -> Void
    
    var body: some View {
        Color.clear
            .onAppear(perform: onVisible)
    }
}

// MARK: - View Extensions

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func applyButtonStyle(
        foregroundColor: Color = .primary,
        backgroundColor: Color = AppColors.accentLight.color
    ) -> some View {
        font(.system(size: 16, weight: .medium))
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(backgroundColor)
            .cornerRadius(10)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
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

// MARK: - Text Handling Extension

extension ChapterReadingView {
    func paragraphView(_ paragraph: String, index: Int, proxy: ScrollViewProxy) -> some View {
        let isCurrentParagraph = index == currentParagraphIndex && isReading
        let highlightSentenceIndex = isCurrentParagraph ? currentSentenceIndex : -1
        
        return ZStack(alignment: .topLeading) {
            Text(highlightedText(paragraph, sentenceIndex: highlightSentenceIndex))
                .font(.custom("Georgia", size: fontSize))
                .lineSpacing(lineSpacing)
                .allowsHitTesting(false)
                .accessibilityIdentifier("\(AccessibilityIdentifiers.paragraphText.rawValue)\(index)")
            
            Button(action: {
                selectWholeParagraph(paragraph)
            }) {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .id("para-\(index)")
    }
    
    func highlightedText(_ paragraph: String, sentenceIndex: Int) -> AttributedString {
        var result = AttributedString(paragraph)
        
        result.font = .custom("Georgia", size: fontSize)
        result.foregroundColor = AppColors.accentDark.color
        
        if sentenceIndex < 0 {
            return result
        }
        
        let sentences = splitIntoSentences(paragraph)
        guard sentences.count > sentenceIndex else {
            return result
        }
        
        var startIndex = 0
        for i in 0 ..< sentenceIndex {
            if i < sentences.count {
                startIndex += sentences[i].count
            }
        }
        
        let currentSentence = sentences[sentenceIndex]
        let endIndex = startIndex + currentSentence.count
        
        guard startIndex < paragraph.count && endIndex <= paragraph.count else {
            return result
        }
        
        let utf16StartIndex = paragraph.utf16.distance(from: paragraph.startIndex,
                                                       to: paragraph.index(paragraph.startIndex, offsetBy: startIndex))
        let utf16EndIndex = paragraph.utf16.distance(from: paragraph.startIndex,
                                                     to: paragraph.index(paragraph.startIndex, offsetBy: endIndex))
        let range = NSRange(location: utf16StartIndex, length: utf16EndIndex - utf16StartIndex)
        
        if let attributedStringRange = Range(range, in: result) {
            result[attributedStringRange].foregroundColor = AppColors.secondary.color
        }
        
        return result
    }
    
    func splitIntoSentences(_ text: String) -> [String] {
        let pattern = "([.!?](?:\\s|$))"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        var sentences: [String] = []
        var lastEnd = 0
        
        if let regex = regex {
            let nsString = text as NSString
            let matches = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            
            for match in matches {
                let sentenceEnd = match.range.location + match.range.length
                let sentenceRange = NSRange(location: lastEnd, length: sentenceEnd - lastEnd)
                sentences.append(nsString.substring(with: sentenceRange))
                lastEnd = sentenceEnd
            }
            
            if lastEnd < nsString.length {
                sentences.append(nsString.substring(with: NSRange(location: lastEnd, length: nsString.length - lastEnd)))
            }
        } else {
            sentences = [text]
        }
        
        return sentences.filter { !$0.isEmpty }
    }
    
    func calculateReadingTime(for sentence: String) -> TimeInterval {
        let wordCount = sentence.split(separator: " ").count
        let wordsPerMinute: Double = 180
        let minutes = Double(wordCount) / wordsPerMinute
        return max(minutes * 60, 0.8)
    }
    
    func selectWholeParagraph(_ paragraph: String) {
        selectedText = paragraph
        withAnimation(.spring()) {
            showQuoteOverlay = true
        }
    }
}

// MARK: - Reading Control Extension

extension ChapterReadingView {
    func startReading(at index: Int, proxy: ScrollViewProxy?) {
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
            self.advanceToNextSentence()
        }
    }
    
    func resumeAutoScrolling(proxy: ScrollViewProxy) {
        autoScrollEnabled = true
        
        isScrollingProgrammatically = true
        withAnimation {
            proxy.scrollTo("para-\(currentParagraphIndex)", anchor: .center)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isScrollingProgrammatically = false
        }
    }
    
    func stopReading() {
        isReading = false
        autoScrollEnabled = false
        readingWorkItem?.cancel()
        readingWorkItem = nil
    }
    
    func advanceToNextSentence() {
        readingWorkItem?.cancel()
        
        guard isReading, currentParagraphIndex < paragraphs.count else {
            if currentParagraphIndex >= paragraphs.count {
                stopReading()
            }
            return
        }
        
        let paragraph = paragraphs[currentParagraphIndex]
        let sentences = splitIntoSentences(paragraph)
        
        if currentSentenceIndex >= sentences.count {
            if currentParagraphIndex + 1 < paragraphs.count {
                currentParagraphIndex += 1
                currentSentenceIndex = 0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.advanceToNextSentence()
                }
            } else {
                stopReading()
            }
            return
        }
        
        let sentence = sentences[currentSentenceIndex]
        let readingTime = calculateReadingTime(for: sentence)
        
        let workItem = DispatchWorkItem {
            guard self.isReading else { return }
            
            DispatchQueue.main.async {
                self.currentSentenceIndex += 1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.advanceToNextSentence()
                }
            }
        }
        
        readingWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + readingTime, execute: workItem)
    }
}

// MARK: - Navigation Elements Extension

extension ChapterReadingView {
    var leadingToolbarItem: ToolbarItem<Void, some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: { self.dismiss() }) {
                HStack {
                    AppIcons.arrowLeft.image
                        .renderingMode(.template)
                    Text(L10n.Book.goBack)
                }.foregroundColor(.accentDark)
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.chapterBackButton.rawValue)
        }
    }
    
    var principalToolbarItem: ToolbarItem<Void, some View> {
        ToolbarItem(placement: .principal) {
            VStack {
                Text(self.book.title)
                    .appFont(.h2)
                    .accessibilityIdentifier(AccessibilityIdentifiers.bookTitle.rawValue)
                
                Text(self.currentChapter.title)
                    .appFont(.bodySmall)
                    .accessibilityIdentifier(AccessibilityIdentifiers.chapterTitle.rawValue)
            }
            .foregroundStyle(.accentDark)
        }
    }
    
    var chapterTabBar: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                customIconButton(icon: AppIcons.previous.image) {
                    if let currentIndex = book.chapters.firstIndex(where: { $0.id == currentChapter.id }) {
                        let previousIndex = currentIndex - 1
                        if previousIndex >= 0 {
                            stopReading()
                            currentChapter = book.chapters[previousIndex]
                        }
                    }
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.chapterPreviousButton.rawValue)
                customIconButton(icon: AppIcons.contents.image) {
                    withAnimation { showChapters.toggle() }
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.chapterContentsButton.rawValue)
                
                customIconButton(icon: AppIcons.next.image) {
                    if let currentIndex = book.chapters.firstIndex(where: { $0.id == currentChapter.id }) {
                        let nextIndex = currentIndex + 1
                        if nextIndex < book.chapters.count {
                            stopReading()
                            currentChapter = book.chapters[nextIndex]
                        }
                    }
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.chapterNextButton.rawValue)
                customIconButton(icon: AppIcons.settings.image) {
                    withAnimation { showSettings.toggle() }
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.chapterSettingsButton.rawValue)
            }
            .padding(.leading, 8)
            
            customIconButton(
                icon: isReading ?
                    (isReading ? AppIcons.pause.image : AppIcons.play.image) :
                    AppIcons.play.image
            ) {
                withAnimation {
                    if !isReading {
                        startReading(at: currentParagraphIndex, proxy: nil)
                    } else {
                        autoScrollEnabled = false
                        isReading = false
                    }
                }
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.chapterPlayButton.rawValue)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .foregroundColor(AppColors.white.color)
        .background(AppColors.accentDark.color)
    }
    
    func customIconButton(icon: Image, action: @escaping () -> Void) -> some View {
        if icon == AppIcons.play.image || icon == AppIcons.pause.image {
            return AnyView(
                Button(action: action) {
                    ZStack {
                        Circle()
                            .fill(AppColors.accentLight.color)
                            .frame(width: 52, height: 52)
                        icon
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .foregroundColor(AppColors.accentDark.color)
                    }.padding(.top, 16)
                        .padding(.trailing, 16)
                }.buttonStyle(NoFadeButtonStyle())
            )
        } else {
            return AnyView(
                Button(action: action) {
                    icon
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            )
        }
    }
}

// MARK: - Quote Selection Overlay Extension

extension ChapterReadingView {
    var quoteSelectionOverlay: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)
                        .accessibilityIdentifier(AccessibilityIdentifiers.quoteDragIndicator.rawValue)
                    
                    ScrollView {
                        TextEditor(text: $selectedText)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(.accentDark)
                            .frame(height: 150)
                            .padding(12)
                            .background(AppColors.accentLight.color.opacity(0.2))
                            .cornerRadius(12)
                            .accessibilityIdentifier(AccessibilityIdentifiers.quoteTextEditor.rawValue)
                            .onChange(of: selectedText) { newValue in
                                
                                if newValue.count > originalSelectedText.count {
                                    selectedText = originalSelectedText
                                }
                                
                                if !originalSelectedText.contains(newValue) && !newValue.isEmpty {
                                    selectedText = originalSelectedText
                                }
                            }
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.quoteScrollView.rawValue)
                    .frame(maxHeight: 200)
                    .padding(.horizontal, 20)
                    
                    Button {
                        selectedText = originalSelectedText
                    } label: {
                        Text("Восстановить исходный текст")
                            .font(.system(size: 14))
                            .foregroundColor(.accentDark)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.quoteRestoreButton.rawValue)
                    .padding(.horizontal, 20)
                    .opacity(selectedText != originalSelectedText ? 1 : 0.3)
                    .disabled(selectedText == originalSelectedText)
                    
                    HStack(spacing: 12) {
                        Button {
                            withAnimation {
                                showQuoteOverlay = false
                                selectedText = ""
                                originalSelectedText = ""
                            }
                        } label: {
                            Text("Отмена")
                                .foregroundStyle(.accentDark)
                                .applyButtonStyle(backgroundColor: AppColors.accentLight.color)
                        }
                        .accessibilityIdentifier(AccessibilityIdentifiers.quoteCancelButton.rawValue)
                        
                        Button {
                            withAnimation {
                                showQuoteOverlay = false
                                selectedText = ""
                                originalSelectedText = ""
                            }
                        } label: {
                            Text("Добавить в цитаты")
                                .applyButtonStyle(foregroundColor: .white, backgroundColor: AppColors.accentDark.color)
                        }
                        .accessibilityIdentifier(AccessibilityIdentifiers.quoteAddButton.rawValue)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? geometry.safeAreaInsets.bottom : 30)
                }
                .background(AppColors.background.color)
                .cornerRadius(16, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.quoteOverlay.rawValue)
            .edgesIgnoringSafeArea(.bottom)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.height > 70 {
                            withAnimation {
                                showQuoteOverlay = false
                                selectedText = ""
                                originalSelectedText = ""
                            }
                        }
                    }
            )
        }
        .onAppear {
            if originalSelectedText.isEmpty {
                originalSelectedText = selectedText
            }
        }
        .transition(.move(edge: .bottom))
        .zIndex(2)
    }
}

// MARK: - Settings Overlay Extension

extension ChapterReadingView {
    var settingsOverlay: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 16) {
                    overlaySettingsTitle(L10n.Book.Settings.title, action: {
                        withAnimation {
                            self.showSettings = false
                        }
                    })
                    
                    fontSizeControl
                    
                    lineSpacingControl
                    
                    Spacer(minLength: 16)
                }
                .padding(.top, 32)
                .padding(.horizontal, 16)
                .frame(height: min(350, geometry.size.height * 0.35))
                .background(AppColors.background.color)
                .cornerRadius(8, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .transition(.move(edge: .bottom))
        .zIndex(1)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 50 {
                        withAnimation {
                            self.showSettings = false
                        }
                    }
                }
        )
    }
    
    var fontSizeControl: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(L10n.Book.Settings.font)
                .appFont(.body)
                .foregroundStyle(.accentDark)
                .accessibilityIdentifier(AccessibilityIdentifiers.fontSizeLabel.rawValue)
            
            HStack(spacing: 0) {
                Text("\(Int(self.fontSize)) " + L10n.Book.Settings.measure)
                    .appFont(.body)
                    .foregroundStyle(.accentDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .accessibilityIdentifier(AccessibilityIdentifiers.fontSizeValue.rawValue)
                
                HStack(spacing: 0) {
                    Button(action: {
                        if self.fontSize > 14 {
                            self.fontSize -= 2
                        }
                    }) {
                        Image(systemName: "minus")
                            .foregroundStyle(.accentDark)
                            .frame(width: 47, height: 32)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.fontSizeDecreaseButton.rawValue)
                    Rectangle()
                        .fill(.accentMedium)
                        .frame(width: 1, height: 18)
                    
                    Button(action: {
                        if self.fontSize < 24 {
                            self.fontSize += 2
                        }
                    }) {
                        Image(systemName: "plus")
                            .foregroundStyle(.accentDark)
                            .frame(width: 47, height: 32)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.fontSizeIncreaseButton.rawValue)
                }
                .background(AppColors.accentLight.color)
                .cornerRadius(10)
            }
        }
    }
    
    var lineSpacingControl: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(L10n.Book.Settings.padding)
                .appFont(.body)
                .foregroundStyle(.accentDark)
                .accessibilityIdentifier(AccessibilityIdentifiers.lineSpacingLabel.rawValue)
            
            HStack(spacing: 0) {
                Text("\(Int(self.lineSpacing)) " + L10n.Book.Settings.measure)
                    .appFont(.body)
                    .foregroundStyle(.accentDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .accessibilityIdentifier(AccessibilityIdentifiers.lineSpacingValue.rawValue)
                
                HStack(spacing: 0) {
                    Button(action: {
                        if self.lineSpacing > 4 {
                            self.lineSpacing -= 2
                        }
                    }) {
                        Image(systemName: "minus")
                            .foregroundStyle(.accentDark)
                            .frame(width: 47, height: 32)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.lineSpacingDecreaseButton.rawValue)
                    
                    Rectangle()
                        .fill(.accentMedium)
                        .frame(width: 1, height: 18)
                    
                    Button(action: {
                        if self.lineSpacing < 12 {
                            self.lineSpacing += 2
                        }
                    }) {
                        Image(systemName: "plus")
                            .foregroundStyle(.accentDark)
                            .frame(width: 47, height: 32)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.lineSpacingIncreaseButton.rawValue)
                }
                .background(AppColors.accentLight.color)
                .cornerRadius(10)
            }
        }
    }
    
    func overlaySettingsTitle(_ title: String, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .appFont(.h2)
                .accessibilityIdentifier(AccessibilityIdentifiers.settingsTitle.rawValue)
                    
            Spacer()
            Button(action: action) {
                AppIcons.close.image
                    .renderingMode(.template)
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.settingsCloseButton.rawValue)
        }.foregroundColor(.accentDark)
    }
}

// MARK: - Chapters Overlay Extension

extension ChapterReadingView {
    var chaptersOverlay: some View {
        GeometryReader { geometry in
            bottomOverlay {
                VStack(spacing: 0) {
                    overlayDragIndicator
                        .accessibilityIdentifier(AccessibilityIdentifiers.chaptersDragIndicator.rawValue)
                    
                    overlayTitle(L10n.Book.contents, action: {
                        withAnimation {
                            self.showChapters = false
                        }
                    })
                    Divider()
                        .foregroundStyle(AppColors.accentLight.color)
                    
                    chaptersListView
                        .accessibilityIdentifier(AccessibilityIdentifiers.chaptersListView.rawValue)
                }
            }
            .frame(height: geometry.size.height)
            .transition(.move(edge: .bottom))
            .zIndex(1)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.height > 100 {
                            withAnimation {
                                self.showChapters = false
                            }
                        }
                    }
            )
        }
    }
    
    var chaptersListView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(self.book.chapters) { chapter in
                    ChapterListItem(chapter: chapter) {
                        withAnimation {
                            self.showChapters = false
                            currentChapter = book.chapters[chapter.number]
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
    }
    
    func bottomOverlay<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            Spacer()
            
            content()
                .background(AppColors.background.color)
                .cornerRadius(16, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    var overlayDragIndicator: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(Color.gray.opacity(0.5))
            .frame(width: 40, height: 5)
            .padding(.vertical, 10)
    }
    
    func overlayTitle(_ title: String, action: @escaping () -> Void) -> some View {
        ZStack {
            HStack {
                Button(action: action) {
                    HStack {
                        AppIcons.arrowLeft.image
                            .renderingMode(.template)
                        
                        Text(L10n.Book.goBack)
                    }
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.chaptersCloseButton.rawValue)
                
                Spacer()
            }
            .padding(.leading)
            
            Text(title.uppercased())
                .appFont(.h2)
                .frame(maxWidth: .infinity, alignment: .center)
                .accessibilityIdentifier(AccessibilityIdentifiers.chaptersTitle.rawValue)
        }
        .foregroundColor(.accentDark)
        .padding(.bottom, 8)
    }
    
    func overlayActionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .applyButtonStyle(
                    foregroundColor: .white,
                    backgroundColor: AppColors.accentLight.color
                )
        }
    }
}
