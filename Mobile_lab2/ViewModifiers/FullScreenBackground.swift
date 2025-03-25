//
//  FullScreenBackground.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct FullScreenBackground: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        ZStack {
            color.edgesIgnoringSafeArea(.all)
            content
        }
    }
}

extension View {
    func fullScreenBackground(_ color: Color) -> some View {
        modifier(FullScreenBackground(color: color))
    }
}
