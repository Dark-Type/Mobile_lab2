//
//  LoginButtonStyleModifier.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import SwiftUI

struct LoginButtonStyleModifier: ViewModifier {
    let isFormValid: Bool

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(isFormValid ? AppColors.white.color : AppColors.accentMedium.color)
            .foregroundColor(isFormValid ? AppColors.accentDark.color : AppColors.white.color)
            .cornerRadius(10)
    }
}

extension View {
    func loginButtonStyle(isFormValid: Bool) -> some View {
        modifier(LoginButtonStyleModifier(isFormValid: isFormValid))
    }
}
