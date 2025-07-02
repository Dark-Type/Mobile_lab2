//
//  LoginButtonView.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import ComposableArchitecture
import SwiftUI

struct LoginButtonView: View {
    let viewStore: ViewStoreOf<LoginFeature>
    let config: LoginLayoutConfig

    var body: some View {
        WithPerceptionTracking {
            Button(action: { viewStore.send(.loginButtonTapped) }, label: {
                LoginButtonContent(viewStore: viewStore)
            })
            .frame(height: config.buttonHeight)
            .accessibilityIdentifier(AccessibilityIdentifiers.loginButton.rawValue)
            .disabled(!viewStore.isLoginEnabled)
        }
    }
}

struct LoginButtonContent: View {
    let viewStore: ViewStoreOf<LoginFeature>

    var body: some View {
        WithPerceptionTracking {
            HStack {
                if viewStore.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(
                            tint: viewStore.isFormValid ? AppColors.accentDark.color : AppColors.white.color
                        ))
                }
                Text(L10n.Login.button)
            }
            .modifier(LoginButtonStyleModifier(isFormValid: viewStore.isFormValid))
        }
    }
}
