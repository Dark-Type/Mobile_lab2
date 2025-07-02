//
//  LoginErrorView.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import ComposableArchitecture
import SwiftUI

struct LoginErrorView: View {
    let message: String
    let viewStore: ViewStoreOf<LoginFeature>

    var body: some View {
        WithPerceptionTracking {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)

                Text(message)
                    .foregroundColor(.red)
                    .appFont(.bodySmall)

                Spacer()

                Button("Dismiss") {
                    viewStore.send(.clearError)
                }
                .foregroundColor(.red)
                .appFont(.bodySmall)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
        }
    }
}
