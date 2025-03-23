//
//  CustomTextLabel.swift
//  Mobile_lab2
//
//  Created by dark type on 23.03.2025.
//

import SwiftUI

struct CustomTextLabel: UIViewRepresentable {
    private var text: String
    private var font: UIFont
    private var color: UIColor
    private var lineHeightMultiple: CGFloat
    private var alignment: NSTextAlignment
    private var lineLimit: Int?
    private var maxWidth: CGFloat?
    private var truncationMode: NSLineBreakMode
    
    init(text: String = "") {
        self.text = text
        self.font = .systemFont(ofSize: 14)
        self.color = .label
        self.lineHeightMultiple = 1.0
        self.alignment = .left
        self.lineLimit = nil
        self.maxWidth = nil
        self.truncationMode = .byTruncatingTail
    }
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = lineLimit ?? 0
        label.lineBreakMode = truncationMode
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        // Apply width constraint directly to the UILabel
        if let width = maxWidth {
            uiView.preferredMaxLayoutWidth = width
        }
        
        // Configure number of lines and truncation
        uiView.numberOfLines = lineLimit ?? 0
        uiView.lineBreakMode = truncationMode
        
        // Create and apply paragraph style
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

// Add modifiers to set constraints
extension CustomTextLabel {
    func text(_ text: String) -> CustomTextLabel {
        var view = self
        view.text = text
        return view
    }
    
    func font(_ font: UIFont) -> CustomTextLabel {
        var view = self
        view.font = font
        return view
    }
    
    func foregroundColor(_ color: UIColor) -> CustomTextLabel {
        var view = self
        view.color = color
        return view
    }
    
    func lineHeightMultiple(_ value: CGFloat) -> CustomTextLabel {
        var view = self
        view.lineHeightMultiple = value
        return view
    }
    
    func textAlignment(_ alignment: NSTextAlignment) -> CustomTextLabel {
        var view = self
        view.alignment = alignment
        return view
    }
    
    func foregroundColor(_ color: Color) -> CustomTextLabel {
        foregroundColor(UIColor(color))
    }
    
    func appFont(_ appFont: AppFont) -> CustomTextLabel {
        if let uiFont = UIFont(name: appFont.name, size: appFont.size) {
            return font(uiFont)
        } else {
            return font(UIFont.systemFont(ofSize: appFont.size))
        }
    }
    
    // Add width constraint modifier
    func maxWidth(_ width: CGFloat?) -> CustomTextLabel {
        var view = self
        view.maxWidth = width
        return view
    }
    
    // Add line limit modifier
    func lineLimit(_ limit: Int?) -> CustomTextLabel {
        var view = self
        view.lineLimit = limit
        // Automatically set appropriate truncation mode
        if let limit = limit, limit == 1 {
            view.truncationMode = .byTruncatingTail
        }
        return view
    }
    
    // Add explicit truncation mode modifier
    func truncationMode(_ mode: NSLineBreakMode) -> CustomTextLabel {
        var view = self
        view.truncationMode = mode
        return view
    }
}
