//
//  AuthRequestInterceptor.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

import Alamofire
import Foundation

public final class AuthRequestInterceptor: RequestInterceptor, Sendable {
    private let tokenStorage: TokenStorage
    private let authRepository: AuthRepositoryProtocol
    private let refreshRequestProvider: @Sendable () async -> RefreshRequest?
    private let refreshState = RefreshState()

    public init(
        tokenStorage: TokenStorage,
        authRepository: AuthRepositoryProtocol,
        refreshRequestProvider: @escaping @Sendable () async -> RefreshRequest?
    ) {
        self.tokenStorage = tokenStorage
        self.authRepository = authRepository
        self.refreshRequestProvider = refreshRequestProvider
    }

    public func adapt(_ urlRequest: URLRequest, for session: Session) async throws -> URLRequest {
        var request = urlRequest
        if let token = await tokenStorage.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    public func retry(_ request: Request, for session: Session, dueTo error: Error) async -> RetryResult {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            return .doNotRetry
        }

        if await refreshState.shouldStartRefresh() {
            do {
                guard let refreshRequest = await refreshRequestProvider() else {
                    await refreshState.completeAll(.doNotRetry)
                    return .doNotRetry
                }
                let response = try await authRepository.refresh(refreshRequest)
                await tokenStorage.setToken(response.jwt)
                await refreshState.completeAll(.retry)
                return .retry
            } catch {
                await refreshState.completeAll(.doNotRetry)
                return .doNotRetry
            }
        } else {
            return await refreshState.waitForRefresh()
        }
    }
}
