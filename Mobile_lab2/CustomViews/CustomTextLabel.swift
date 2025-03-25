//
//  CustomTextLabel.swift
//  Mobile_lab2
//
//  Created by dark type on 23.03.2025.
//

import SwiftUI

struct CustomTextLabel: UIViewRepresentable {
    // MARK: - Constants

    private enum Defaults {
        static let fontSize: CGFloat = 14
        static let lineHeightMultiple: CGFloat = 1.0
        static let alignment: NSTextAlignment = .left
        static let truncationMode: NSLineBreakMode = .byTruncatingTail
    }

    // MARK: - Properties

    private var text: String
    private var font: UIFont
    private var color: UIColor
    private var lineHeightMultiple: CGFloat
    private var alignment: NSTextAlignment
    private var lineLimit: Int?
    private var maxWidth: CGFloat?
    private var truncationMode: NSLineBreakMode

    // MARK: - Initialization

    init(text: String = "") {
        self.text = text
        self.font = .systemFont(ofSize: Defaults.fontSize)
        self.color = .label
        self.lineHeightMultiple = Defaults.lineHeightMultiple
        self.alignment = Defaults.alignment
        self.lineLimit = nil
        self.maxWidth = nil
        self.truncationMode = Defaults.truncationMode
    }

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = lineLimit ?? 0
        label.lineBreakMode = truncationMode
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        if let width = maxWidth {
            uiView.preferredMaxLayoutWidth = width
        }
        uiView.numberOfLines = lineLimit ?? 0
        uiView.lineBreakMode = truncationMode

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = truncationMode
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: color,
                .paragraphStyle: paragraphStyle
            ]
        )
        uiView.attributedText = attributedString
    }
}

// MARK: - Modifiers

extension CustomTextLabel {
    /// Sets the text content of the label
    func text(_ text: String) -> CustomTextLabel {
        var view = self
        view.text = text
        return view
    }

    /// Sets the UIFont of the label
    func font(_ font: UIFont) -> CustomTextLabel {
        var view = self
        view.font = font
        return view
    }

    /// Sets the text color using UIColor
    func foregroundColor(_ color: UIColor) -> CustomTextLabel {
        var view = self
        view.color = color
        return view
    }

    /// Sets the line height multiple for the text
    func lineHeightMultiple(_ value: CGFloat) -> CustomTextLabel {
        var view = self
        view.lineHeightMultiple = value
        return view
    }

    /// Sets the text alignment
    func textAlignment(_ alignment: NSTextAlignment) -> CustomTextLabel {
        var view = self
        view.alignment = alignment
        return view
    }

    /// Sets the text color using SwiftUI Color
    func foregroundColor(_ color: Color) -> CustomTextLabel {
        foregroundColor(UIColor(color))
    }

    /// Sets the font using AppFont type
    func appFont(_ appFont: AppFont) -> CustomTextLabel {
        if let uiFont = UIFont(name: appFont.name, size: appFont.size) {
            return font(uiFont)
        } else {
            return font(UIFont.systemFont(ofSize: appFont.size))
        }
    }

    /// Sets the maximum width of the label
    func maxWidth(_ width: CGFloat?) -> CustomTextLabel {
        var view = self
        view.maxWidth = width
        return view
    }

    /// Sets the maximum number of lines to display
    func lineLimit(_ limit: Int?) -> CustomTextLabel {
        var view = self
        view.lineLimit = limit
        if let limit = limit, limit == 1 {
            view.truncationMode = .byTruncatingTail
        }
        return view
    }

    /// Sets the line break mode for truncating text
    func truncationMode(_ mode: NSLineBreakMode) -> CustomTextLabel {
        var view = self
        view.truncationMode = mode
        return view
    }
}
