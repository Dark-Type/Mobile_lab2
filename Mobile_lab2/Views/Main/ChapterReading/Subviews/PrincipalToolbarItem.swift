//
//  PrincipalToolbarItem.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import SwiftUI

struct PrincipalToolbarItem: ToolbarContent {
    let book: BookUI
    let currentChapter: Chapter

    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack {
                Text(book.title)
                    .appFont(.header2)
                    .accessibilityIdentifier(AccessibilityIdentifiers.bookTitle.rawValue)
                Text(currentChapter.title)
                    .appFont(.bodySmall)
                    .accessibilityIdentifier(AccessibilityIdentifiers.chapterTitle.rawValue)
            }
            .foregroundStyle(.accentDark)
        }
    }
}
