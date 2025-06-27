//
//  ChapterTabBar.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import SwiftUI

struct ChapterTabBar: View {
    let book: Book
    @Binding var currentChapter: Chapter
    @Binding var showChapters: Bool
    @Binding var showSettings: Bool
    @Binding var isReading: Bool
    @Binding var autoScrollEnabled: Bool
    @Binding var currentParagraphIndex: Int
    var onStartReading: (Int) -> Void

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                customIconButton(icon: AppIcons.previous.image) {
                    if let currentIndex = book.chapters.firstIndex(where: { $0.id == currentChapter.id }) {
                        let previousIndex = currentIndex - 1
                        if previousIndex >= 0 {
                            isReading = false
                            autoScrollEnabled = false
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
                            isReading = false
                            autoScrollEnabled = false
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
                        onStartReading(currentParagraphIndex)
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
