//
//  ChapterListItem.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct ChapterListItem: View {
    let chapter: Chapter
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(chapter.title)
                        .appFont(statusFont)
                        .foregroundColor(.accentDark)
                        
                }
                
                Spacer()
                
                statusIcon?
                    .renderingMode(.template)
                    .foregroundColor(statusColor)
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var statusIcon: Image? {
        if chapter.isFinished {
            return AppIcons.read.image
        } else if chapter.isStarted {
            return AppIcons.readingNow.image
        } else {
            return nil
        }
    }
    private var statusFont: AppFont {
        if chapter.isStarted && !chapter.isFinished {
            return AppFont.body
        }
        else {
            return AppFont.bodySmall
        }
    }

    
    private var statusColor: Color {
        if chapter.isFinished {
            return AppColors.accentMedium.color
        } else if chapter.isStarted {
            return AppColors.accentDark.color
        } else {
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
