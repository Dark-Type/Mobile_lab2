//
//  SettingsOverlayView.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import SwiftUI

struct SettingsOverlayView: View {
    @Binding var fontSize: CGFloat
    @Binding var lineSpacing: CGFloat
    @Binding var showSettings: Bool
    let onFontSizeIncrease: () -> Void
    let onFontSizeDecrease: () -> Void
    let onLineSpacingIncrease: () -> Void
    let onLineSpacingDecrease: () -> Void
    let onClose: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 16) {
                    overlaySettingsTitle(L10n.Book.Settings.title)
                    fontSizeControl
                    lineSpacingControl
                    Spacer(minLength: 16)
                }
                .padding(.top, 32)
                .padding(.horizontal, 16)
                .frame(height: min(350, geometry.size.height * 0.35))
                .background(AppColors.background.color)
                .cornerRadius(8, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .transition(.move(edge: .bottom))
        .zIndex(1)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 50 {
                        withAnimation {
                            showSettings = false
                        }
                    }
                }
        )
    }

    private var fontSizeControl: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(L10n.Book.Settings.font)
                .appFont(.body)
                .foregroundStyle(.accentDark)
                .accessibilityIdentifier(AccessibilityIdentifiers.fontSizeLabel.rawValue)

            HStack(spacing: 0) {
                Text("\(Int(fontSize)) " + L10n.Book.Settings.measure)
                    .appFont(.body)
                    .foregroundStyle(.accentDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .accessibilityIdentifier(AccessibilityIdentifiers.fontSizeValue.rawValue)

                HStack(spacing: 0) {
                    Button(action: onFontSizeDecrease) {
                        Image(systemName: "minus")
                            .foregroundStyle(.accentDark)
                            .frame(width: 47, height: 32)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.fontSizeDecreaseButton.rawValue)

                    Rectangle()
                        .fill(.accentMedium)
                        .frame(width: 1, height: 18)

                    Button(action: onFontSizeIncrease) {
                        Image(systemName: "plus")
                            .foregroundStyle(.accentDark)
                            .frame(width: 47, height: 32)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.fontSizeIncreaseButton.rawValue)
                }
                .background(AppColors.accentLight.color)
                .cornerRadius(10)
            }
        }
    }

    private var lineSpacingControl: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(L10n.Book.Settings.padding)
                .appFont(.body)
                .foregroundStyle(.accentDark)
                .accessibilityIdentifier(AccessibilityIdentifiers.lineSpacingLabel.rawValue)

            HStack(spacing: 0) {
                Text("\(Int(lineSpacing)) " + L10n.Book.Settings.measure)
                    .appFont(.body)
                    .foregroundStyle(.accentDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .accessibilityIdentifier(AccessibilityIdentifiers.lineSpacingValue.rawValue)

                HStack(spacing: 0) {
                    Button(action: onLineSpacingDecrease) {
                        Image(systemName: "minus")
                            .foregroundStyle(.accentDark)
                            .frame(width: 47, height: 32)
                    }

                    .accessibilityIdentifier(AccessibilityIdentifiers.lineSpacingDecreaseButton.rawValue)

                    Rectangle()
                        .fill(.accentMedium)
                        .frame(width: 1, height: 18)

                    Button(action: onLineSpacingIncrease) {
                        Image(systemName: "plus")
                            .foregroundStyle(.accentDark)
                            .frame(width: 47, height: 32)
                    }

                    .accessibilityIdentifier(AccessibilityIdentifiers.lineSpacingIncreaseButton.rawValue)
                }
                .background(AppColors.accentLight.color)
                .cornerRadius(10)
            }
        }
    }

    private func overlaySettingsTitle(_ title: String) -> some View {
        HStack {
            Text(title)
                .appFont(.header2)
                .accessibilityIdentifier(AccessibilityIdentifiers.settingsTitle.rawValue)

            Spacer()
            Button(action: onClose) {
                AppIcons.close.image
                    .renderingMode(.template)
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.settingsCloseButton.rawValue)
        }.foregroundColor(.accentDark)
    }
}
