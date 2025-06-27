//
//  AppView.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        WithPerceptionTracking {
            WithViewStore(store, observe: { $0 }, content: { viewStore in
                Group {
                    switch viewStore.authenticationState {
                    case .loggedOut, .authenticating:
                        LoginView(store: store.scope(state: \.login, action: \.login))
                            .loginScreenStyle()

                    case .loggedIn:
                        MainView(store: Store(initialState: MainFeature.State()) {
                            MainFeature()
                        })
                        .transition(.opacity)
                    }
                }
                .onAppear {
                    viewStore.send(.appLaunched)
                }
                .animation(.easeInOut(duration: 0.3), value: viewStore.authenticationState.isLoggedIn)
            })
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
