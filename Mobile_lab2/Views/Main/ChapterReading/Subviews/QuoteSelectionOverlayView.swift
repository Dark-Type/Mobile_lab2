//
//  QuoteSelectionOverlayView.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import SwiftUI

struct QuoteSelectionOverlayView: View {
    @Binding var selectedText: String
    @Binding var originalSelectedText: String
    @Binding var showQuoteOverlay: Bool
    let onTextChange: (String) -> Void
    let onRestore: () -> Void
    let onCancel: () -> Void
    let onAdd: () -> Void
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)
                        .accessibilityIdentifier(AccessibilityIdentifiers.quoteDragIndicator.rawValue)
                    ScrollView {
                        TextEditor(text: $selectedText)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(.accentDark)
                            .frame(height: 150)
                            .padding(12)
                            .background(AppColors.accentLight.color.opacity(0.2))
                            .cornerRadius(12)
                            .accessibilityIdentifier(AccessibilityIdentifiers.quoteTextEditor.rawValue)
                            .onChange(of: selectedText) { newValue in
                                onTextChange(newValue)
                            }
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.quoteScrollView.rawValue)
                    .frame(maxHeight: 200)
                    .padding(.horizontal, 20)
                    Button(action: onRestore) {
                        Text("Восстановить исходный текст")
                            .font(.system(size: 14))
                            .foregroundColor(.accentDark)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.quoteRestoreButton.rawValue)
                    .padding(.horizontal, 20)
                    .opacity(selectedText != originalSelectedText ? 1 : 0.3)
                    .disabled(selectedText == originalSelectedText)
                    HStack(spacing: 12) {
                        Button(action: onCancel) {
                            Text("Отмена")
                                .foregroundStyle(.accentDark)
                                .applyButtonStyle(backgroundColor: AppColors.accentLight.color)
                        }
                        .accessibilityIdentifier(AccessibilityIdentifiers.quoteCancelButton.rawValue)
                        Button(action: onAdd) {
                            Text("Добавить в цитаты")
                                .applyButtonStyle(foregroundColor: .white, backgroundColor: AppColors.accentDark.color)
                        }
                        .accessibilityIdentifier(AccessibilityIdentifiers.quoteAddButton.rawValue)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? geometry.safeAreaInsets.bottom : 30)
                }
                .background(AppColors.background.color)
                .cornerRadius(16, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.quoteOverlay.rawValue)
            .edgesIgnoringSafeArea(.bottom)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.height > 70 {
                            withAnimation {
                                showQuoteOverlay = false
                                selectedText = ""
                                originalSelectedText = ""
                            }
                        }
                    }
            )
        }
        .onAppear {
            if originalSelectedText.isEmpty {
                originalSelectedText = selectedText
            }
        }
        .transition(.move(edge: .bottom))
        .zIndex(2)
    }
}
