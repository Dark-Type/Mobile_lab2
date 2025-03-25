//
//  Mobile_lab2App.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

@main
struct Mobile_lab2App: App {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    init() {
        if ProcessInfo.processInfo.arguments.contains("-ui-testing-logged-in") {
            print("UI TESTING: Setting logged in state to TRUE")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
        } else if ProcessInfo.processInfo.arguments.contains("-ui-testing-logged-out") {
            print("UI TESTING: Setting logged in state to FALSE")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
        }
        if ProcessInfo.processInfo.arguments.contains("-empty-state-test") {
            print("UI TESTING: Running in empty state mode")
        }
    }

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainView()
            } else {
                LoginScreen()
                    .toolbarBackground(.clear, for: .navigationBar)
                    .toolbarBackground(.clear, for: .tabBar)
                    .background(
                        AppColors.accentDark.color
                            .ignoresSafeArea()
                    )
            }
        }
    }
}
