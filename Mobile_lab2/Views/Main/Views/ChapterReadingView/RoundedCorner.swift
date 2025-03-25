//
//  RoundedCorner.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import SwiftUI


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    func applyButtonStyle(
        foregroundColor: Color = .primary,
        backgroundColor: Color = AppColors.accentLight.color
    ) -> some View {
        font(.system(size: 16, weight: .medium))
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(backgroundColor)
            .cornerRadius(10)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
