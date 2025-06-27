//
//  AppFeature.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AppFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        var authenticationState: AuthenticationState
        var login: LoginFeature.State = .init()
        var main: MainFeature.State = .init()

        init() {
            let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            self.authenticationState = isLoggedIn ? .loggedIn(User.mockUser) : .loggedOut
        }
    }

    // MARK: - Authentication State

    enum AuthenticationState: Equatable {
        case loggedOut
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
        case main(MainFeature.Action)
        case logout
        case authenticationStateChanged(AuthenticationState)
    }

    // MARK: - Dependencies

    @Dependency(\.authenticationService) var authenticationService
    @Dependency(\.userDefaultsService) var userDefaultsService

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Scope(state: \.login, action: \.login) {
            LoginFeature()
        }

        Scope(state: \.main, action: \.main) {
            MainFeature()
        }

        Reduce { state, action in
            switch action {
            case .appLaunched:
                if state.authenticationState.isLoggedIn {
                    return .send(.main(.viewAppeared))
                }
                return .none

            case let .login(.loginResponse(.success(user))):
                state.authenticationState = .loggedIn(user)
                return .run { send in
                    await userDefaultsService.setLoggedIn(true)
                    await send(.main(.viewAppeared))
                }

            case .login:
                return .none

            case .logout:
                state.authenticationState = .loggedOut
                state.login = LoginFeature.State()
                state.main = MainFeature.State()

                return .run { _ in
                    try await authenticationService.logout()
                    await userDefaultsService.setLoggedIn(false)
                }

            case let .authenticationStateChanged(newState):
                state.authenticationState = newState
                return .none

            case .main(.delegate(.logout)):
                return .send(.logout)

            case .main:
                return .none
            }
        }
    }
}
