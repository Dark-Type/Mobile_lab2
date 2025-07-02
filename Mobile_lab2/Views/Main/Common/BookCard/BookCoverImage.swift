//
//  BookCoverImage.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import SwiftUI

struct BookCoverImage: View {
    let image: Image
    let width: CGFloat

    private enum ViewMetrics {
        static let cornerRadius: CGFloat = 8
    }

    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width)
            .cornerRadius(ViewMetrics.cornerRadius)
            .clipped()
    }
}
