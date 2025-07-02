//
//  LoginFeature.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct LoginFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var password: String = ""
        var isPasswordVisible: Bool = false
        var isLoading: Bool = false
        var errorMessage: String?

        var selectedCarouselIndex: Int = 0
        var keyboardHeight: CGFloat = 0
        var keyboardIsVisible: Bool { keyboardHeight > 0 }

        var credentials: LoginCredentials {
            LoginCredentials(email: email, password: password)
        }

        var isFormValid: Bool {
            credentials.isValid
        }

        var isLoginEnabled: Bool {
            isFormValid && !isLoading
        }
    }

    // MARK: - Action

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)

        case emailChanged(String)
        case passwordChanged(String)
        case togglePasswordVisibility
        case clearEmail
        case clearPassword
        case loginButtonTapped

        case carouselIndexChanged(Int)
        case keyboardHeightChanged(CGFloat)

        case loginResponse(Result<UserUI, AuthenticationError>)
        case clearError
    }

    // MARK: - Dependencies

    @Dependency(\.authenticationService) var authenticationService

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case let .emailChanged(email):
                state.email = email
                state.errorMessage = nil
                return .none

            case let .passwordChanged(password):
                state.password = password
                state.errorMessage = nil
                return .none

            case .togglePasswordVisibility:
                state.isPasswordVisible.toggle()
                return .none

            case .clearEmail:
                state.email = ""
                state.errorMessage = nil
                return .none

            case .clearPassword:
                state.password = ""
                state.errorMessage = nil
                return .none

            case .loginButtonTapped:
                guard state.isLoginEnabled else { return .none }

                state.isLoading = true
                state.errorMessage = nil

                return .run { [credentials = state.credentials] send in
                    await send(.loginResponse(
                        Result {
                            try await authenticationService.login(credentials: credentials)
                        }
                        .mapError { error in
                            if let authError = error as? AuthenticationError {
                                return authError
                            }
                            return AuthenticationError.networkError
                        }
                    ))
                }

            case let .carouselIndexChanged(index):
                state.selectedCarouselIndex = index
                return .none

            case let .keyboardHeightChanged(height):
                state.keyboardHeight = height
                return .none

            case let .loginResponse(.success(user)):
                state.isLoading = false
                return .none

            case let .loginResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.message
                return .none

            case .clearError:
                state.errorMessage = nil
                return .none
            }
        }
    }
}
