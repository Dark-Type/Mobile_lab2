//
//  KeyboardHandlingModifier.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import SwiftUI

struct KeyboardHandlingModifier: ViewModifier {
    let onKeyboardShow: (CGFloat) -> Void
    let onKeyboardHide: () -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    onKeyboardShow(keyboardFrame.height)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                onKeyboardHide()
            }
    }
}

extension View {
    func handleKeyboard(
        onShow: @escaping (CGFloat) -> Void,
        onHide: @escaping () -> Void
    ) -> some View {
        modifier(KeyboardHandlingModifier(onKeyboardShow: onShow, onKeyboardHide: onHide))
    }
}
