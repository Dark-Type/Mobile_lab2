//
//  LoginScreenStyleModifier.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import SwiftUI

struct LoginScreenStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbarBackground(.clear, for: .tabBar)
            .background(
                AppColors.accentDark.color
                    .ignoresSafeArea()
            )
    }
}

extension View {
    func loginScreenStyle() -> some View {
        modifier(LoginScreenStyleModifier())
    }
}
