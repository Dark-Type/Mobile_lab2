//
//  LoginLayoutConfig.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import SwiftUI

struct LoginLayoutConfig {
    let topPadding: CGFloat
    let carouselHeight: CGFloat
    let verticalSpacing: CGFloat
    let horizontalPadding: CGFloat
    let fieldHeight: CGFloat
    let buttonHeight: CGFloat

    init(screenSize: CGSize, safeAreaInsets: EdgeInsets) {
        let screenHeight = screenSize.height
        let isSmallDevice = screenHeight <= 667

        if isSmallDevice {
            topPadding = 12
            carouselHeight = screenHeight * 0.28
            verticalSpacing = 16
            horizontalPadding = 20
            fieldHeight = 50
            buttonHeight = 52
        } else {
            topPadding = 20
            carouselHeight = screenHeight * 0.32
            verticalSpacing = 24
            horizontalPadding = 24
            fieldHeight = 56
            buttonHeight = 56
        }
    }
}

extension DeviceLayout {
    func responsiveConfig(screenSize: CGSize, safeAreaInsets: EdgeInsets) -> LoginLayoutConfig {
        return LoginLayoutConfig(screenSize: screenSize, safeAreaInsets: safeAreaInsets)
    }
}
