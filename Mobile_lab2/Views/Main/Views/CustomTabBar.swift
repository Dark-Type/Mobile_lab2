//
//  CustomTabBar.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    var logoutAction: () -> Void
    
    // MARK: - Properties

    private let tabBarHeight: CGFloat = 64
    private let middleButtonSize: CGFloat = 80
    
    // MARK: - View

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    tabButton(icon: .library, index: 0)
                    tabButton(icon: .search, index: 1)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                    .frame(width: middleButtonSize + 10)
                
                HStack(spacing: 0) {
                    tabButton(icon: .bookmarks, index: 3)
                    
                    Button(action: logoutAction) {
                        AppIcons.logout.image
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(AppColors.accentMedium.color)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: tabBarHeight)
            .background(
                RoundedRectangle(cornerRadius: 45)
                    .fill(AppColors.accentDark.color)
            )
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            Button(action: { selectedTab = 2 }) {
                ZStack {
                    Circle()
                        .fill(AppColors.secondary.color)
                        .frame(width: middleButtonSize, height: middleButtonSize)
                        .shadow(color: AppColors.secondary.color.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    AppIcons.play.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
            }
            .offset(y: -10)
        }
    }
    
    // MARK: - Helper Views

    private func tabButton(icon: AppIcons, index: Int) -> some View {
        Button(action: {
            selectedTab = index
        }) {
            icon.image
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(selectedTab == index ? AppColors.white.color : AppColors.accentMedium.color)
                .padding()
        }
        .frame(maxWidth: .infinity)
    }
}
