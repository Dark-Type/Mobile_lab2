//
//  ContinuousScrollModifier.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import SwiftUI

private struct ContinuousScrollModifier: ViewModifier {
    let itemWidth: CGFloat
    let totalWidth: CGFloat
    @State private var offset: CGFloat = 0
    @State private var isAnimating: Bool = false

    func body(content: Content) -> some View {
        content
            .offset(x: -offset)
            .onAppear {
                startAnimation()
            }
            .onChange(of: isAnimating) { isAnimating in
                if !isAnimating {
                    startAnimation()
                }
            }
    }

    private func startAnimation() {
        isAnimating = true
        withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
            offset = totalWidth
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
