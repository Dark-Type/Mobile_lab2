//
//  ProgressBar.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct ProgressBar: View {
    // MARK: - Constants
    
    private enum ViewMetrics {
        static let defaultHeight: CGFloat = 5
        static let cornerRadiusFactor: CGFloat = 0.5
    }
    
    // MARK: - Properties
    
    let progress: Double
    let height: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    
    init(
        progress: Double,
        height: CGFloat = ViewMetrics.defaultHeight,
        backgroundColor: Color = AppColors.accentMedium.color,
        foregroundColor: Color = AppColors.accentDark.color
    ) {
        self.progress = min(max(progress, 0.0), 1.0)
        self.height = height
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(backgroundColor)
                    .cornerRadius(height * ViewMetrics.cornerRadiusFactor)
                
                Rectangle()
                    .fill(foregroundColor)
                    .frame(width: geometry.size.width * CGFloat(progress))
                    .cornerRadius(height * ViewMetrics.cornerRadiusFactor)
            }
        }
        .frame(height: height)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressBar(progress: 0.25)
        ProgressBar(progress: 0.5)
        ProgressBar(progress: 0.75)
    }
    .padding()
}
