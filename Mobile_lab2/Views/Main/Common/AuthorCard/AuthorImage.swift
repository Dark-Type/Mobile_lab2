//
//  AuthorImage.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import SwiftUI

struct AuthorImage: View {
    let image: Image

    private enum ViewMetrics {
        static let imageSize: CGFloat = 64
        static let imageCornerRadius: CGFloat = 45
    }

    var body: some View {
        image
            .resizable()
            .frame(
                width: ViewMetrics.imageSize,
                height: ViewMetrics.imageSize
            )
            .cornerRadius(ViewMetrics.imageCornerRadius)
            .clipped(antialiased: true)
    }
}
