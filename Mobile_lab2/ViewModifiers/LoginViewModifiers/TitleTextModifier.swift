//
//  TitleTextModifier.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import SwiftUI

struct TitleTextModifier: ViewModifier {
    let fontSize: CGFloat
    let weight: Font.Weight

    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: weight))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension View {
    func applyTitleStyle(fontSize: CGFloat, weight: Font.Weight) -> some View {
        modifier(TitleTextModifier(fontSize: fontSize, weight: weight))
    }
}
