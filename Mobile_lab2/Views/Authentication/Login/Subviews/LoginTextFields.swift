//
//  LoginTextField.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import SwiftUI

struct LoginTextField: View {
    let placeholder: String
    let text: Binding<String>
    let showClearButton: Bool
    let clearAction: () -> Void
    let fieldHeight: CGFloat

    var body: some View {
        HStack(spacing: 0) {
            FieldLabel(text: placeholder)

            TextField("", text: text)
                .accessibilityIdentifier(AccessibilityIdentifiers.emailTextField.rawValue)
                .foregroundColor(AppColors.accentLight.color)
                .appFont(.bodySmall)

            TrailingButton(
                showButton: showClearButton,
                action: clearAction,
                icon: AppIcons.close.image
            )
        }
        .frame(height: fieldHeight)
    }
}

struct LoginSecureField: View {
    let placeholder: String
    let text: Binding<String>
    let isVisible: Binding<Bool>
    let showClearButton: Bool
    let clearAction: () -> Void
    let fieldHeight: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            FieldDivider()

            HStack(spacing: 0) {
                FieldLabel(text: placeholder)

                Group {
                    if isVisible.wrappedValue {
                        TextField("", text: text)
                            .accessibilityIdentifier(AccessibilityIdentifiers.passwordTextField.rawValue)
                    } else {
                        SecureField("", text: text)
                            .accessibilityIdentifier(AccessibilityIdentifiers.passwordTextField.rawValue)
                    }
                }
                .foregroundStyle(.accentLight)
                .appFont(.bodySmall)

                TrailingButton(
                    showButton: !text.wrappedValue.isEmpty,
                    action: { isVisible.wrappedValue.toggle() },
                    icon: (isVisible.wrappedValue ? AppIcons.eyeOn : AppIcons.eyeOff).image
                )
            }
            .frame(height: fieldHeight)
        }
    }
}

// MARK: - Supporting Components

struct FieldLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .foregroundColor(AppColors.accentMedium.color)
            .frame(width: 100, alignment: .leading)
            .padding(.leading, 16)
            .appFont(.bodySmall)
    }
}

struct FieldDivider: View {
    var body: some View {
        Divider()
            .background(AppColors.accentMedium.color)
            .padding(.leading, 16)
    }
}

struct TrailingButton: View {
    let showButton: Bool
    let action: () -> Void
    let icon: Image

    var body: some View {
        if showButton {
            Button(action: action) {
                icon
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(AppColors.accentLight.color)
                    .frame(width: 24, height: 24)
            }
            .padding(.trailing, 16)
        } else {
            Spacer()
                .frame(width: 16)
        }
    }
}
