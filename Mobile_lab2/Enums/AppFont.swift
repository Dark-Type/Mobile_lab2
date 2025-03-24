//
//  AppFont.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

enum AppFont {
    case title
    case h1
    case h2
    case body
    case bodySmall
    case footnote
    case text
    case quote
    case bold

    var name: String {
        switch self {
        case .title, .h1, .h2:
            return "AlumniSans-Bold"
        case .body, .bodySmall, .footnote:
            return "VelaSans"
        case .text, .quote:
            return "Georgia"
        case .bold:
            return "VelaSans-Bold"
        }
    }

    var size: CGFloat {
        switch self {
        case .title:
            return 96
        case .h1:
            return 48
        case .h2:
            return 24
        case .body:
            return 16
        case .bodySmall:
            return 14
        case .footnote:
            return 10
        case .text:
            return 14
        case .quote:
            return 16
        case .bold:
            return 16
        }
    }

    var lineHeightMultiplier: CGFloat {
        switch self {
        case .title:
            return 0.8
        case .h1:
            return 1.0
        case .h2:
            return 1.0
        case .body:
            return 1.3
        case .bodySmall:
            return 1.3
        case .footnote:
            return 1.3
        case .text:
            return 1.5
        case .quote:
            return 1.3
        case .bold:
            return 1.0
        }
    
    }
}

extension View {
    func appFont(_ style: AppFont) -> some View {
        self.font(.custom(style.name, size: style.size))
            .lineSpacing(style.size * (style.lineHeightMultiplier - 1))
    }
}
extension AppFont {
    func withReadingSettings(fontSize: CGFloat, lineSpacing: CGFloat) -> ReadingFont {
        return ReadingFont(
            baseFontStyle: self,
            fontSize: fontSize,
            lineSpacing: lineSpacing
        )
    }
}

struct ReadingFont {
    let baseFontStyle: AppFont
    let fontSize: CGFloat
    let lineSpacing: CGFloat
    
    var name: String {
        return baseFontStyle.name
    }
}

extension View {
    func readingFont(_ readingFont: ReadingFont) -> some View {
        self
            .font(.custom(readingFont.name, size: readingFont.fontSize))
            .lineSpacing(readingFont.lineSpacing)
    }
}
