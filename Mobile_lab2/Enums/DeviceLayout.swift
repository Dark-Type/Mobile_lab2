//
//  DeviceType.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import Foundation

enum DeviceLayout {
    case small, regular

    init(height: CGFloat) {
        self = height < 700 ? .small : .regular
    }

    func topPadding(safeAreaTop: CGFloat) -> CGFloat {
        safeAreaTop + (self == .small ? 20 : 30)
    }

    func carouselHeight(totalHeight: CGFloat) -> CGFloat {
        totalHeight * (self == .small ? 0.15 : 0.25)
    }

    func verticalSpacing(totalHeight: CGFloat) -> CGFloat {
        totalHeight * (self == .small ? 0.0 : 0.025)
    }

    func horizontalPadding(totalHeight: CGFloat) -> CGFloat {
        totalHeight * (self == .small ? 0.015 : 0.025)
    }

    var loginButtonTopPadding: CGFloat {
        self == .small ? 20 : 30
    }
}
