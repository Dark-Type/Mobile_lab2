//
//  LoginContentLayoutModifier.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import SwiftUI

struct LoginContentLayoutModifier: ViewModifier {
    let horizontalPadding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalPadding)
            .ignoresSafeArea(edges: .horizontal)
    }
}

extension View {
    func loginContentLayout(horizontalPadding: CGFloat) -> some View {
        modifier(LoginContentLayoutModifier(horizontalPadding: horizontalPadding))
    }
}
