//
//  LoginFeature.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import ComposableArchitecture
import Foundation
@preconcurrency import Networking

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
        var isRegisterMode: Bool = false 

        var selectedCarouselIndex: Int = 0
        var keyboardHeight: CGFloat = 0
        var keyboardIsVisible: Bool { keyboardHeight > 0 }

        var loginCredentials: RefreshRequest {
            RefreshRequest(identifier: email, password: password)
        }
        
        var registerCredentials: RegisterRequest {
            RegisterRequest(email: email, password: password, username: email.components(separatedBy: "@").first ?? "user")
        }

        var isFormValid: Bool {
            !email.isEmpty && !password.isEmpty && email.contains("@")
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
        case toggleMode
        case clearEmail
        case clearPassword
        case loginButtonTapped

        case carouselIndexChanged(Int)
        case keyboardHeightChanged(CGFloat)

        case loginResponse(Result<TokenResponse, AuthenticationError>)
        case clearError
    }

    // MARK: - Dependencies

    @Dependency(\.authRepository) var authRepository
    @Dependency(\.userDefaultsService) var userDefaultsService
   

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
                
            case .toggleMode:
                state.isRegisterMode.toggle()
                state.errorMessage = nil
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

                if state.isRegisterMode {
                    return .run { [credentials = state.registerCredentials, email = state.email, password = state.password] send in
                        await send(.loginResponse(
                            Result {
                                let response = try await authRepository.register(credentials)
                                await userDefaultsService.setCredentials(email: email, password: password)
                                return response
                            }
                            .mapError { error in
                                if let authError = error as? AuthenticationError {
                                    return authError
                                }
                                return AuthenticationError.networkError
                            }
                        ))
                    }
                } else {
                    return .run { [credentials = state.loginCredentials, email = state.email, password = state.password] send in
                        await send(.loginResponse(
                            Result {
                                let response = try await authRepository.login(credentials)
                                await userDefaultsService.setCredentials(email: email, password: password)
                                return response
                            }
                            .mapError { error in
                                if let authError = error as? AuthenticationError {
                                    return authError
                                }
                                return AuthenticationError.networkError
                            }
                        ))
                    }
                }

            case let .carouselIndexChanged(index):
                state.selectedCarouselIndex = index
                return .none

            case let .keyboardHeightChanged(height):
                state.keyboardHeight = height
                return .none

            case let .loginResponse(.success(tokenResponse)):
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
