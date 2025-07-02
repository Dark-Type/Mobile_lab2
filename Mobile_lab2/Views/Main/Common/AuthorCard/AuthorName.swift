//
//  AuthorName.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import SwiftUI

struct AuthorName: View {
    let name: String

    private enum ViewMetrics {
        static let textLeadingPadding: CGFloat = 16
    }

    var body: some View {
        Text(name)
            .appFont(.body)
            .foregroundColor(.accentDark)
            .padding(.leading, ViewMetrics.textLeadingPadding)
    }
}
