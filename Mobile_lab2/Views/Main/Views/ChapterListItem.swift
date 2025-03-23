//
//  ChapterListItem.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct ChapterListItem: View {
    // MARK: - Properties

    let chapter: Chapter
    let action: () -> Void
    
    // MARK: - Constants

    private enum ViewMetrics {
        static let verticalSpacing: CGFloat = 4
        static let verticalPadding: CGFloat = 12
    }
    
    // MARK: - Body

    var body: some View {
        Button(action: action) {
            itemContent
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Private Views

    private var itemContent: some View {
        HStack {
            chapterTitle
            Spacer()
            chapterStatusIcon
        }
        .padding(.vertical, ViewMetrics.verticalPadding)
    }
    
    private var chapterTitle: some View {
        VStack(alignment: .leading, spacing: ViewMetrics.verticalSpacing) {
            Text(chapter.title)
                .appFont(statusFont)
                .foregroundColor(.accentDark)
        }
    }
    
    private var chapterStatusIcon: some View {
        Group {
            if let icon = statusIcon {
                icon
                    .renderingMode(.template)
                    .foregroundColor(statusColor)
            }
        }
    }
    
    // MARK: - Computed Properties

    private var statusIcon: Image? {
        switch (chapter.isFinished, chapter.isStarted) {
        case (true, _):
            return AppIcons.read.image
        case (false, true):
            return AppIcons.readingNow.image
        default:
            return nil
        }
    }

    private var statusFont: AppFont {
        if chapter.isStarted && !chapter.isFinished {
            return .body
        } else {
            return .bodySmall
        }
    }

    private var statusColor: Color {
        switch (chapter.isFinished, chapter.isStarted) {
        case (true, _):
            return AppColors.accentMedium.color
        case (false, true):
            return AppColors.accentDark.color
        default:
            return .clear
        }
    }
}

#Preview {
    VStack {
        ChapterListItem(
            chapter: Chapter(
                title: "The Beginning",
                number: 1,
                content: "Lorem ipsum dolor sit amet",
                isStarted: false,
                isFinished: false
            ),
            action: {}
        )
        
        ChapterListItem(
            chapter: Chapter(
                title: "The Journey",
                number: 2,
                content: "Lorem ipsum dolor sit amet",
                isStarted: true,
                isFinished: false
            ),
            action: {}
        )
        
        ChapterListItem(
            chapter: Chapter(
                title: "The Resolution",
                number: 3,
                content: "Lorem ipsum dolor sit amet",
                isStarted: true,
                isFinished: true
            ),
            action: {}
        )
    }
    .padding()
}
