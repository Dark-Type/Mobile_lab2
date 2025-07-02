//
//  ParagraphView.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import SwiftUI
import ComposableArchitecture

struct ParagraphView: View {
    let paragraph: String
    let index: Int
    let isCurrentParagraph: Bool
    let currentSentenceIndex: Int
    let fontSize: CGFloat
    let lineSpacing: CGFloat
    let onSelect: (String) -> Void

    @State private var displayText = AttributedString("")
    @State private var lastUpdateKey: String = ""

    private var updateKey: String {
        "\(isCurrentParagraph)-\(currentSentenceIndex)-\(fontSize)"
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(displayText)
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
        .onChange(of: updateKey) { newKey in
            if newKey != lastUpdateKey {
                lastUpdateKey = newKey
                updateDisplayText()
            }
        }
        .onAppear {
            updateDisplayText()
        }
    }

    private func updateDisplayText() {
        let highlightSentenceIndex = isCurrentParagraph ? currentSentenceIndex : -1

        DispatchQueue.main.async {
            let highlighted = TextProcessingUtils.highlightedText(
                paragraph,
                sentenceIndex: highlightSentenceIndex,
                fontSize: fontSize,
                accentDarkColor: AppColors.accentDark.color,
                secondaryColor: AppColors.secondary.color
            )

            withAnimation(.easeInOut(duration: 0.2)) {
                displayText = highlighted
            }
        }
    }
}
