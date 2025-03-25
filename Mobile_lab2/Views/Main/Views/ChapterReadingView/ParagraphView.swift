//
//  ParagraphView.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import SwiftUI

struct ParagraphView: View {
    let paragraph: String
    let index: Int
    let isCurrentParagraph: Bool
    let currentSentenceIndex: Int
    let fontSize: CGFloat
    let lineSpacing: CGFloat
    let onSelect: (String) -> Void

    var body: some View {
        let highlightSentenceIndex = isCurrentParagraph ? currentSentenceIndex : -1

        return ZStack(alignment: .topLeading) {
            Text(TextProcessingUtils.highlightedText(
                paragraph,
                sentenceIndex: highlightSentenceIndex,
                fontSize: fontSize,
                accentDarkColor: AppColors.accentDark.color,
                secondaryColor: AppColors.secondary.color
            ))
            .font(.custom("Georgia", size: fontSize))
            .lineSpacing(lineSpacing)
            .allowsHitTesting(false)
            .accessibilityIdentifier("\(AccessibilityIdentifiers.paragraphText.rawValue)\(index)")

            Button(
                action: {
                    onSelect(paragraph)
                },
                label: {
                    Color.clear
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            )
            .buttonStyle(BorderlessButtonStyle())
        }
        .id("para-\(index)")
    }
}
