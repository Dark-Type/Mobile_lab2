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
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewStore.isFormValid ? AppColors.white.color : AppColors.accentMedium.color)
            .foregroundColor(viewStore.isFormValid ? AppColors.accentDark.color : AppColors.white.color)
            .cornerRadius(10)
        }
    }
}

struct LoginErrorView: View {
    let message: String
    let viewStore: ViewStoreOf<LoginFeature>

    var body: some View {
        WithPerceptionTracking {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)

                Text(message)
                    .foregroundColor(.red)
                    .appFont(.bodySmall)

                Spacer()

                Button("Dismiss") {
                    viewStore.send(.clearError)
                }
                .foregroundColor(.red)
                .appFont(.bodySmall)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
        }
    }
}
