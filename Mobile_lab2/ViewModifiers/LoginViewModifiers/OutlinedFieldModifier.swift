//
//  OutlinedFieldModifier.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import SwiftUI

struct OutlinedFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColors.accentMedium.color, lineWidth: 1)
            )
    }
}
extension View {
    func applyOutlinedFieldStyle() -> some View {
        modifier(OutlinedFieldModifier())
    }
}
