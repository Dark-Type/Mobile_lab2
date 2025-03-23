//
//  CustomTabBar.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct CustomTabBar: View {
    // MARK: - Properties

    @Binding var selectedTab: Int
    var readingAction: () -> Void
    var logoutAction: () -> Void
    
    // MARK: - Constants

    private enum ViewMetrics {
        static let tabBarHeight: CGFloat = 64
        static let middleButtonSize: CGFloat = 80
        static let middleButtonOffset: CGFloat = -10
        static let middleButtonSpacing: CGFloat = 10
        static let iconSize: CGFloat = 24
        static let cornerRadius: CGFloat = 45
        static let bottomPadding: CGFloat = 20
    }
    
    // MARK: - Body

    var body: some View {
        ZStack {
            tabBarBackground
            middleButton
        }
    }
    
    // MARK: - Private Views

    private var tabBarBackground: some View {
        HStack(spacing: 0) {
            leftTabButtons
            
            middleButtonSpace
            
            rightTabButtons
        }
        .frame(height: ViewMetrics.tabBarHeight)
        .background(
            RoundedRectangle(cornerRadius: ViewMetrics.cornerRadius)
                .fill(AppColors.accentDark.color)
        )
        .padding(.horizontal)
        .padding(.bottom, ViewMetrics.bottomPadding)
    }
    
    private var leftTabButtons: some View {
        HStack(spacing: 0) {
            tabButton(icon: .library, index: 0)
            tabButton(icon: .search, index: 1)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var middleButtonSpace: some View {
        Spacer()
            .frame(width: ViewMetrics.middleButtonSize + ViewMetrics.middleButtonSpacing)
    }
    
    private var rightTabButtons: some View {
        HStack(spacing: 0) {
            tabButton(icon: .bookmarks, index: 2)
            logoutButton
        }
        .frame(maxWidth: .infinity)
    }
    
    private var logoutButton: some View {
        Button(action: logoutAction) {
            AppIcons.logout.image
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: ViewMetrics.iconSize,
                    height: ViewMetrics.iconSize
                )
                .foregroundColor(AppColors.accentMedium.color)
                .padding()
        }
        .frame(maxWidth: .infinity)
    }
    
    private var middleButton: some View {
        Button(action: readingAction) {
            ZStack {
                Circle()
                    .fill(AppColors.secondary.color)
                    .frame(
                        width: ViewMetrics.middleButtonSize,
                        height: ViewMetrics.middleButtonSize
                    )
                
                AppIcons.play.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: ViewMetrics.iconSize,
                        height: ViewMetrics.iconSize
                    )
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(NoFadeButtonStyle())
        .offset(y: ViewMetrics.middleButtonOffset)
    }
    
    private func tabButton(icon: AppIcons, index: Int) -> some View {
        Button(action: {
            selectedTab = index
        }) {
            icon.image
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: ViewMetrics.iconSize,
                    height: ViewMetrics.iconSize
                )
                .foregroundColor(tabIconColor(for: index))
                .padding()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Helper Methods

    private func tabIconColor(for index: Int) -> Color {
        selectedTab == index
            ? AppColors.white.color
            : AppColors.accentMedium.color
    }
}

struct NoFadeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
