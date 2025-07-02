//
//  AuthorCardStyleModifier.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import SwiftUI

struct AuthorCardStyleModifier: ViewModifier {
    private enum ViewMetrics {
        static let cardPadding: CGFloat = 16
        static let cardCornerRadius: CGFloat = 12
    }

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(ViewMetrics.cardPadding)
            .background(Color.accentLight)
            .cornerRadius(ViewMetrics.cardCornerRadius)
    }
}

extension View {
    func authorCardStyle() -> some View {
        self.modifier(AuthorCardStyleModifier())
    }
}
