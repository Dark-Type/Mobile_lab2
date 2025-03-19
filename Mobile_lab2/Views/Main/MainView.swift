//
//  MainView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//


import SwiftUI

struct MainView: View {
    // MARK: - State
    @State private var selectedTab = 0
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    
    // MARK: - View
    var body: some View {
        TabView(selection: $selectedTab) {
            LibraryScreen()
                .tag(0)
            
            SearchScreen()
                .tag(1)
            
            ReadingScreen()
                .tag(2)
            
            BookmarksScreen()
                .tag(3)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .safeAreaInset(edge: .bottom) {
            CustomTabBar(
                selectedTab: $selectedTab,
                logoutAction: performLogout
            )
        }
        .background(AppColors.background.color)
    }
    
    // MARK: - Actions
    private func performLogout() {
        withAnimation {
            isLoggedIn = false
        }
    }
}


// MARK: - Preview
#Preview {
    MainView()
}
