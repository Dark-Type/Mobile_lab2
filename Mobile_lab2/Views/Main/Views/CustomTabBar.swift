//
//  CustomTabBar.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    var readingAction: () -> Void
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
                    tabButton(icon: .bookmarks, index: 2)
                    
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
            
            Button(action: { readingAction() }) {
                ZStack {
                    Circle()
                        .fill(AppColors.secondary.color)
                        .frame(width: middleButtonSize, height: middleButtonSize)
                    
                    AppIcons.play.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(NoFadeButtonStyle())
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

struct NoFadeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
