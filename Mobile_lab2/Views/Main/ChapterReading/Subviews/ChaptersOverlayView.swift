//
//  ChaptersOverlayView.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import SwiftUI
import Perception
struct ChaptersOverlayView: View {
    let book: Book
    @Binding var currentChapter: Chapter
    @Binding var showChapters: Bool
    let onChapterSelected: (Chapter) -> Void

    var body: some View {
        WithPerceptionTracking {
            GeometryReader { geometry in
                bottomOverlay {
                    VStack(spacing: 0) {
                        overlayDragIndicator
                            .accessibilityIdentifier(AccessibilityIdentifiers.chaptersDragIndicator.rawValue)

                        overlayTitle(L10n.Book.contents, action: {
                            withAnimation {
                                showChapters = false
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
                                    showChapters = false
                                }
                            }
                        }
                )
            }
        }
    }

    private var chaptersListView: some View {
        WithPerceptionTracking {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(book.chapters) { chapter in
                        ChapterListItem(chapter: chapter) {
                            withAnimation {
                                onChapterSelected(chapter)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
    }

    private func bottomOverlay<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            Spacer()

            content()
                .background(AppColors.background.color)
                .cornerRadius(16, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }

    private var overlayDragIndicator: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(Color.gray.opacity(0.5))
            .frame(width: 40, height: 5)
            .padding(.vertical, 10)
    }

    private func overlayTitle(_ title: String, action: @escaping () -> Void) -> some View {
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
                .appFont(.header2)
                .frame(maxWidth: .infinity, alignment: .center)
                .accessibilityIdentifier(AccessibilityIdentifiers.chaptersTitle.rawValue)
        }
        .foregroundColor(.accentDark)
        .padding(.bottom, 8)
    }
}
