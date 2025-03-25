//
//  LeadingToolbarItem.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import SwiftUI

struct LeadingToolbarItem: ToolbarContent {
    let dismiss: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(
                action: {
                    dismiss()
                },
                label: {
                    HStack {
                        AppIcons.arrowLeft.image
                            .renderingMode(.template)
                        Text(L10n.Book.goBack)
                    }.foregroundColor(.accentDark)
                }
            )
            .accessibilityIdentifier(AccessibilityIdentifiers.chapterBackButton.rawValue)
        }
    }
}
