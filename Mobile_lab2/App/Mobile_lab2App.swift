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

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainView()
                    .fullScreenBackground(AppColors.background.color)
            } else {
                LoginView()
                    .fullScreenBackground(AppColors.accentDark.color)
            }
        }
    }
}
