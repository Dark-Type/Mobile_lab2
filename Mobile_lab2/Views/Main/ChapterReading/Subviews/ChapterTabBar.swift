//
//  ChapterTabBar.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import ComposableArchitecture
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
