//
//  LoginTitleSection.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import SwiftUI

struct LoginTitleSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            FirstTitleLine()
                .padding(.bottom, 8)

            SecondTitleLine()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FirstTitleLine: View {
    var body: some View {
        GeometryReader { geometry in
            CustomTextLabel()
                .text(L10n.Login.Title.first.uppercased())
                .appFont(AppFont.header1)
                .foregroundColor(AppColors.accentLight.color)
                .lineHeightMultiple(1.0)
                .lineLimit(1)
                .maxWidth(geometry.size.width)
                .truncationMode(.byTruncatingTail)
                .accessibilityIdentifier(AccessibilityIdentifiers.titleFirstLine.rawValue)
        }
        .frame(height: AppFont.header1.size * 1.2)
    }
}

struct SecondTitleLine: View {
    var body: some View {
        GeometryReader { geometry in
            CustomTextLabel()
                .text(L10n.Login.Title.second.uppercased())
                .appFont(AppFont.title)
                .foregroundColor(AppColors.secondary.color)
                .lineHeightMultiple(0.7)
                .lineLimit(2)
                .maxWidth(geometry.size.width)
                .truncationMode(.byTruncatingTail)
                .accessibilityIdentifier(AccessibilityIdentifiers.titleSecondLine.rawValue)
        }
        .frame(height: AppFont.title.size * 2)
    }
}
