//
//  AppFeature.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import ComposableArchitecture
import Foundation
import Networking
@Reducer
struct AppFeature {
    // MARK: - State

    @ObservableState
    struct State: Equatable {
        var authenticationState: AuthenticationState
        var login: LoginFeature.State = .init()
        var main: MainFeature.State = .init()
        var networkStatus: NetworkStatus = .connected

        init() {
            let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            self.authenticationState = isLoggedIn ? .loggedIn(UserUI.mockUser) : .loggedOut
        }
    }

    // MARK: - Authentication State

    enum AuthenticationState: Equatable {
        case loggedOut
        case loggedIn(TokenResponse)

        var isLoggedIn: Bool {
            if case .loggedIn = self {
                return true
            }
            return false
        }

        var currentUser: UserUI? {
            if case let .loggedIn(token) = self {
                return token.user
            }
            return nil
        }
    }

    // MARK: - Action

    enum Action: Equatable {
        case appLaunched
        case login(LoginFeature.Action)
        case main(MainFeature.Action)
        case networkStatusChanged(NetworkStatus)
        case logout
        case authenticationStateChanged(AuthenticationState)
    }

    // MARK: - Dependencies

    @Dependency(\.authRepository) var authReportository
    @Dependency(\.userDefaultsService) var userDefaultsService
    @Dependency(\.networkStatus) var networkStatus
    @Dependency(\.tokenStorage) var tokenStorage
    
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
                return .run { send in
                    for await status in networkStatus.observe() {
                        await send(.networkStatusChanged(status))
                    }
                }

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
                    await userDefaultsService.setLoggedIn(false)
                    await tokenStorage.removeToken()
                }

            case let .authenticationStateChanged(newState):
                state.authenticationState = newState
                return .none

            case let .networkStatusChanged(status):
                print("[AppFeature] Received network status: \(status)")
                state.networkStatus = status
                return .none

            case .main(.delegate(.logout)):
                return .send(.logout)

            case .main:
                return .none
            }
        }
    }
}
