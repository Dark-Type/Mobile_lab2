//
//  CarouselFrameModifier.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import SwiftUI

struct CarouselFrameModifier: ViewModifier {
    let height: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .padding(.top)
            .ignoresSafeArea(edges: .horizontal)
    }
}

extension View {
    func carouselFrame(height: CGFloat) -> some View {
        modifier(CarouselFrameModifier(height: height))
    }
}
