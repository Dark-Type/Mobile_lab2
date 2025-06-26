//
//  LoginFormView.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import ComposableArchitecture
import SwiftUI

struct LoginFormView: View {
    let viewStore: ViewStoreOf<LoginFeature>
    let config: LoginLayoutConfig

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                LoginTextField(
                    placeholder: L10n.Login.email,
                    text: viewStore.binding(
                        get: \.email,
                        send: LoginFeature.Action.emailChanged
                    ),
                    showClearButton: !viewStore.email.isEmpty,
                    clearAction: { viewStore.send(.clearEmail) },
                    fieldHeight: config.fieldHeight
                )

                LoginSecureField(
                    placeholder: L10n.Login.password,
                    text: viewStore.binding(
                        get: \.password,
                        send: LoginFeature.Action.passwordChanged
                    ),
                    isVisible: viewStore.binding(
                        get: \.isPasswordVisible,
                        send: { _ in .togglePasswordVisibility }
                    ),
                    showClearButton: !viewStore.password.isEmpty,
                    clearAction: { viewStore.send(.clearPassword) },
                    fieldHeight: config.fieldHeight
                )
            }
            .applyOutlinedFieldStyle()
        }
    }
}
