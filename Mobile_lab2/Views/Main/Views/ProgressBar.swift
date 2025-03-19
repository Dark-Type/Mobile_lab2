//
//  ProgressBar.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//


import SwiftUI

struct ProgressBar: View {
    let progress: Double
    let height: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    
    init(
        progress: Double,
        height: CGFloat = 5,
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
                    .cornerRadius(height / 2)
                
                Rectangle()
                    .fill(foregroundColor)
                    .frame(width: geometry.size.width * CGFloat(progress))
                    .cornerRadius(height / 2)
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
