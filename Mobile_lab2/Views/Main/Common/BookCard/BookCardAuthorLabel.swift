//
//  BookCardAuthorLabel.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import SwiftUI

struct BookCardAuthorLabel: View {
    let author: Author
    let width: CGFloat

    private enum ViewMetrics {
        static let lineHeightMultiple: CGFloat = 1.0
    }

    var body: some View {
        CustomTextLabel()
            .text(author.name)
            .appFont(.bodySmall)
            .foregroundColor(AppColors.accentDark.color)
            .lineHeightMultiple(ViewMetrics.lineHeightMultiple)
            .lineLimit(1)
            .maxWidth(width)
            .truncationMode(.byTruncatingTail)
            .frame(height: calculateTextHeight(font: .bodySmall, lines: 1))
    }

    private func calculateTextHeight(font: AppFont, lines: Int) -> CGFloat {
        font.size * ViewMetrics.lineHeightMultiple * CGFloat(lines)
    }
}
