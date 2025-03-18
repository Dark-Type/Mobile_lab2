//
//  AppColor.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

enum AppColors {
    case accentDark
    case accentLight
    case accentMedium
    case background
    case black
    case secondary
    case white

    // MARK: - Color Value

    var color: Color {
        switch self {
        case .accentDark: return Color("AccentDark")
        case .accentLight: return Color("AccentLight")
        case .accentMedium: return Color("AccentMedium")
        case .background: return Color("Background")
        case .black: return Color("AppBlack")
        case .secondary: return Color("SecondaryRed")
        case .white: return Color("AppWhite")
        }
    }
}

// MARK: - SwiftUI Integration Extensions

extension View {
    func foregroundStyle(_ appColor: AppColors) -> some View {
        self.foregroundStyle(appColor.color)
    }

    func backgroundColor(_ appColor: AppColors) -> some View {
        self.background(appColor.color)
    }

    func borderColor(_ appColor: AppColors, width: CGFloat = 1) -> some View {
        self.border(appColor.color, width: width)
    }
}
