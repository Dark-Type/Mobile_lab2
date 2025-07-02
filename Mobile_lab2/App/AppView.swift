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
                VStack(spacing: 0) {
                    if viewStore.networkStatus == .disconnected {
                        Text("Нет Интернет соединения 🚫🛜")
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .zIndex(1)
                    }
                    Group {
                        switch viewStore.authenticationState {
                        case .loggedOut:
                            LoginView(store: store.scope(state: \.login, action: \.login))
                                .loginScreenStyle()
                                .transition(.opacity)
                        case .loggedIn:
                            MainView(store: store.scope(state: \.main, action: \.main))
                                .transition(.opacity)
                        }
                    }
                    .onAppear {
                        viewStore.send(.appLaunched)
                    }
                    .animation(.easeInOut(duration: 0.3), value: viewStore.authenticationState.isLoggedIn)
                }
            })
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
