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
        safeAreaTop + (self == .small ? 10 : -40)
    }

    func carouselHeight(totalHeight: CGFloat) -> CGFloat {
        self == .small ? 200 :  300
    }

    func verticalSpacing(totalHeight: CGFloat) -> CGFloat {
        totalHeight * (self == .small ? 0.04 : 0.05)
    }

    func horizontalPadding(totalHeight: CGFloat) -> CGFloat {
        totalHeight * (self == .small ? 0.015 : 0.025)
    }

    var loginButtonTopPadding: CGFloat {
        self == .small ? 20 : 30
    }
}
