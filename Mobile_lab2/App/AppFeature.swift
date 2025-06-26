//
//  AppFeature.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import ComposableArchitecture
import Foundation

// MARK: - App Feature

@Reducer
struct AppFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        var authenticationState: AuthenticationState = .loggedOut
        var login: LoginFeature.State = .init()
    }

    // MARK: - Authentication State

    enum AuthenticationState: Equatable {
        case loggedOut
        case authenticating
        case loggedIn(User)

        var isLoggedIn: Bool {
            if case .loggedIn = self {
                return true
            }
            return false
        }

        var currentUser: User? {
            if case let .loggedIn(user) = self {
                return user
            }
            return nil
        }
    }

    // MARK: - Action

    enum Action: Equatable {
        case appLaunched
        case login(LoginFeature.Action)
        case logout
        case authenticationStateChanged(AuthenticationState)
    }

    // MARK: - Dependencies

    @Dependency(\.authenticationService) var authenticationService

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Scope(state: \.login, action: \.login) {
            LoginFeature()
        }

        Reduce { state, action in
            switch action {
            case .appLaunched:
                let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
                if isLoggedIn {
                    return .run { send in
                        if let user = await authenticationService.getCurrentUser() {
                            await send(.authenticationStateChanged(.loggedIn(user)))
                        }
                    }
                }
                return .none

            case let .login(.loginResponse(.success(user))):
                state.authenticationState = .loggedIn(user)

                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                return .none

            case .login:
                return .none

            case .logout:
                state.authenticationState = .loggedOut
                state.login = LoginFeature.State()

                return .run { _ in
                    try await authenticationService.logout()
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                }

            case let .authenticationStateChanged(newState):
                state.authenticationState = newState
                return .none
            }
        }
    }
}
