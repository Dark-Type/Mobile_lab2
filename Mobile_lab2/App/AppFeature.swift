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
            self.authenticationState = .loggedOut
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

        var currentUser: User? {
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
        case tryAutoLogin
    }

    // MARK: - Dependencies

    @Dependency(\.authRepository) var authRepository
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
                    async let networkTask: () = {
                        for await status in networkStatus.observe() {
                            await send(.networkStatusChanged(status))
                        }
                    }()
                    
                    if await userDefaultsService.getLoggedIn() {
                        await send(.tryAutoLogin)
                    }
                    
                    await networkTask
                }

            case .tryAutoLogin:
                return .run { send in
                    guard let credentials = await userDefaultsService.getCredentials(),
                          await tokenStorage.getToken() != nil else {
                        await userDefaultsService.setLoggedIn(false)
                        return
                    }
                    
                    do {
                        let refreshRequest = RefreshRequest(identifier: credentials.email, password: credentials.password)
                        let response = try await authRepository.refresh(refreshRequest)
                        await send(.authenticationStateChanged(.loggedIn(response)))
                        await userDefaultsService.setLoggedIn(true)
                    } catch {
                        await userDefaultsService.setLoggedIn(false)
                        await userDefaultsService.removeCredentials()
                        await tokenStorage.removeToken()
                    }
                }

            case let .login(.loginResponse(.success(tokenResponse))):
                state.authenticationState = .loggedIn(tokenResponse)
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
                    await userDefaultsService.removeCredentials()
                    await tokenStorage.removeToken()
                }

            case let .authenticationStateChanged(newState):
                state.authenticationState = newState
                return .none

            case let .networkStatusChanged(status):
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
