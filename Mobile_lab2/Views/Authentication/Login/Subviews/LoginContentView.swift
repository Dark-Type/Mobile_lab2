//
//  LoginContentView.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import ComposableArchitecture
import SwiftUI

struct LoginContentView: View {
    let viewStore: ViewStoreOf<LoginFeature>

    var body: some View {
        WithPerceptionTracking {
            GeometryReader { geometry in
                let config = LoginLayoutConfig(
                    screenSize: geometry.size,
                    safeAreaInsets: geometry.safeAreaInsets
                )

                ScrollView(showsIndicators: false) {
                    LoginScrollContent(viewStore: viewStore, config: config)
                }
                .background(AppColors.accentDark.color.ignoresSafeArea())
            }
        }
    }
}

struct LoginScrollContent: View {
    let viewStore: ViewStoreOf<LoginFeature>
    let config: LoginLayoutConfig

    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .top) {
                LoginCarouselView(selectedIndex: viewStore.selectedCarouselIndex)
                    .carouselFrame(height: config.carouselHeight)

                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: config.carouselHeight + config.verticalSpacing)

                    LoginTitleSection()
                        .padding(.top, config.topPadding)

                    LoginFormView(viewStore: viewStore, config: config)

                    if let errorMessage = viewStore.errorMessage {
                        LoginErrorView(message: errorMessage, viewStore: viewStore)
                            .padding(.top, 8)
                    }

                    LoginButtonView(viewStore: viewStore, config: config)
                        .padding(.top, config.verticalSpacing)
                        .padding(.bottom, config.verticalSpacing)
                }
                .loginContentLayout(horizontalPadding: config.horizontalPadding)
                .handleKeyboard(
                    onShow: { height in viewStore.send(.keyboardHeightChanged(height)) },
                    onHide: { viewStore.send(.keyboardHeightChanged(0)) }
                )
            }
        }
    }
}
