//
//  ChapterReadingView.swift
//  Mobile_lab2
//
//  Created by dark type on 19.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct ChapterReadingView: View {
    let store: StoreOf<ChapterReadingFeature>
    let onSetCurrentBook: ((Book) -> Void)?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        WithPerceptionTracking {
            WithViewStore(store, observe: { $0 }, content: { viewStore in
                ChapterReadingContentView(
                    viewStore: viewStore,
                    store: store,
                    onSetCurrentBook: onSetCurrentBook
                )
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                LeadingToolbarItem(dismiss: { dismiss() })
                PrincipalToolbarItem(book: store.book, currentChapter: store.currentChapter)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar(store.showChapters || store.showSettings || store.showQuoteOverlay ? .hidden : .automatic, for: .navigationBar)
        }
    }
}

// MARK: - Main Content View

private struct ChapterReadingContentView: View {
    let viewStore: ViewStore<ChapterReadingFeature.State, ChapterReadingFeature.Action>
    let store: StoreOf<ChapterReadingFeature>
    let onSetCurrentBook: ((Book) -> Void)?

    var body: some View {
        WithPerceptionTracking {
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
                                viewStore.send(.scrollStateChanged(false))

                            })
                            .frame(height: 1)

                            LazyVStack(alignment: .leading, spacing: 16) {
                                ForEach(Array(viewStore.paragraphs.enumerated()), id: \.offset) { index, paragraph in
                                    ParagraphView(
                                        paragraph: paragraph,
                                        index: index,
                                        isCurrentParagraph: index == viewStore.currentParagraphIndex && viewStore.isReading,
                                        currentSentenceIndex: viewStore.currentSentenceIndex,
                                        fontSize: viewStore.fontSize,
                                        lineSpacing: viewStore.lineSpacing,
                                        onSelect: { paragraph in
                                            viewStore.send(.paragraphSelected(paragraph))
                                        }
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
                                        viewStore.send(.scrollStateChanged(true))
                                    }

                                    if viewStore.isReading, viewStore.autoScrollEnabled, !viewStore.isScrollingProgrammatically {
                                        viewStore.send(.autoScrollToggled(false))
                                    }
                                }
                        )
                    }
                    .onChange(of: viewStore.shouldScrollToParagraph) { paragraphIndex in
                        guard let paragraphIndex = paragraphIndex,
                              paragraphIndex < viewStore.paragraphs.count,
                              viewStore.isReading,
                              viewStore.autoScrollEnabled else { return }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                proxy.scrollTo("para-\(paragraphIndex)", anchor: .center)
                                viewStore.send(.scrollStateChanged(true))
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                viewStore.send(.setScrollingProgrammatically(false))
                            }
                        }
                    }
                    .onChange(of: viewStore.currentChapter) { _ in
                        proxy.scrollTo("para-0", anchor: .top)
                    }
                }

                WithPerceptionTracking {
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
                            .opacity(viewStore.hasScrolled ? 1 : 0)
                        Spacer()
                    }
                    .allowsHitTesting(false)
                    .frame(maxHeight: .infinity, alignment: .top)
                }

                WithPerceptionTracking {
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

                        ChapterTabBarView(viewStore: viewStore)
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
                }

                WithPerceptionTracking {
                    Group {
                        if viewStore.showChapters {
                            ChaptersOverlayView(
                                book: viewStore.book,
                                currentChapter: .constant(viewStore.currentChapter),
                                showChapters: .constant(viewStore.showChapters)
                            ) { chapter in
                                viewStore.send(.chapterSelected(chapter))
                            }
                        }

                        if viewStore.showSettings {
                            SettingsOverlayView(
                                fontSize: .constant(viewStore.fontSize),
                                lineSpacing: .constant(viewStore.lineSpacing),
                                showSettings: .constant(viewStore.showSettings),
                                onFontSizeIncrease: { viewStore.send(.fontSizeIncreased) },
                                onFontSizeDecrease: { viewStore.send(.fontSizeDecreased) },
                                onLineSpacingIncrease: { viewStore.send(.lineSpacingIncreased) },
                                onLineSpacingDecrease: { viewStore.send(.lineSpacingDecreased) },
                                onClose: { viewStore.send(.toggleSettingsOverlay) }
                            )
                        }

                        if viewStore.showQuoteOverlay {
                            QuoteSelectionOverlayView(
                                selectedText: .constant(viewStore.selectedText),
                                originalSelectedText: .constant(viewStore.originalSelectedText),
                                showQuoteOverlay: .constant(viewStore.showQuoteOverlay),
                                onTextChange: { text in viewStore.send(.selectedTextChanged(text)) },
                                onRestore: { viewStore.send(.restoreOriginalText) },
                                onCancel: { viewStore.send(.cancelQuoteSelection) },
                                onAdd: { viewStore.send(.addQuote) }
                            )
                        }
                    }
                }
            }
            .onAppear {
                viewStore.send(.viewAppeared)
                onSetCurrentBook?(viewStore.book)
            }
            .onDisappear {
                viewStore.send(.viewDisappeared)
            }
            .background(
                AppColors.background.color
                    .ignoresSafeArea()
            )
        }
    }
}

// MARK: - Chapter Tab Bar View

private struct ChapterTabBarView: View {
    let viewStore: ViewStore<ChapterReadingFeature.State, ChapterReadingFeature.Action>

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                customIconButton(icon: AppIcons.previous.image) {
                    viewStore.send(.previousChapterTapped)
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.chapterPreviousButton.rawValue)

                customIconButton(icon: AppIcons.contents.image) {
                    viewStore.send(.toggleChaptersOverlay)
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.chapterContentsButton.rawValue)

                customIconButton(icon: AppIcons.next.image) {
                    viewStore.send(.nextChapterTapped)
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.chapterNextButton.rawValue)

                customIconButton(icon: AppIcons.settings.image) {
                    viewStore.send(.toggleSettingsOverlay)
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.chapterSettingsButton.rawValue)
            }
            .padding(.leading, 8)

            customIconButton(
                icon: viewStore.isReading ? AppIcons.pause.image : AppIcons.play.image
            ) {
                withAnimation {
                    if !viewStore.isReading {
                        viewStore.send(.startReading(viewStore.currentParagraphIndex))
                    } else {
                        viewStore.send(.stopReading)
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
                Button(
                    action: action,
                    label: {
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
                    }
                ).buttonStyle(NoFadeButtonStyle())
            )
        } else {
            return AnyView(
                Button(
                    action: action,
                    label: {
                        icon
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                )
            )
        }
    }
}

// MARK: - Preview

// #Preview {
//    NavigationStack {
//        ChapterReadingView(
//            store: Store(
//                initialState: ChapterReadingFeature.State(
//                    book: MockData.books[0],
//                    chapter: MockData.books[0].chapters[1]
//                )
//            ) {
//                ChapterReadingFeature()
//            }, onSetCurrentBook: <#((Book) -> Void)?#>
//        )
//    }
// }
