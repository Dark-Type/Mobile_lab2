//
//  BookCardTitleLabel.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import SwiftUI

struct BookCardTitleLabel: View {
    let title: String
    let width: CGFloat

    private enum ViewMetrics {
        static let lineHeightMultiple: CGFloat = 1.0
    }

    var body: some View {
        CustomTextLabel()
            .text(title.uppercased())
            .appFont(.header2)
            .foregroundColor(AppColors.accentDark.color)
            .lineHeightMultiple(ViewMetrics.lineHeightMultiple)
            .lineLimit(2)
            .maxWidth(width)
            .truncationMode(.byTruncatingTail)
            .frame(height: calculateTextHeight(font: .header2, lines: 2))
    }

    private func calculateTextHeight(font: AppFont, lines: Int) -> CGFloat {
        font.size * ViewMetrics.lineHeightMultiple * CGFloat(lines)
    }
}
