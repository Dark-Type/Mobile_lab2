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
    @State private var isReadingScreenPresented = false
    @AppStorage("isLoggedIn") private var isLoggedIn = true

    // MARK: - View

    var body: some View {
        ZStack {
            AppColors.background.color
                .ignoresSafeArea()

            TabView(selection: $selectedTab) {
                LibraryScreen()
                    .tag(0)

                SearchScreen()
                    .tag(1)

                BookmarksScreen()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .background(Color.clear)
            .safeAreaInset(edge: .bottom) {
                CustomTabBar(
                    selectedTab: $selectedTab,
                    readingAction: { isReadingScreenPresented = true },
                    logoutAction: performLogout
                )
            }
        }
        .fullScreenCover(isPresented: $isReadingScreenPresented) {
            NavigationStack {
                ReadingScreen(book: MockData.books[0])
                    .toolbarBackground(Color.clear, for: .navigationBar)
            }
        }
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
