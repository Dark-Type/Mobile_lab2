//
//  LoginView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct LoginView: View {
    let store: StoreOf<LoginFeature>

    var body: some View {
        WithPerceptionTracking {
            WithViewStore(store, observe: { $0 }, content: { viewStore in
                LoginContentView(viewStore: viewStore)
            })
        }
    }
}

#Preview {
    LoginView(store: Store(initialState: LoginFeature.State()) {
        LoginFeature()
    })
}
