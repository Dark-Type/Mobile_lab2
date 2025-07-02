//
//  AuthRequestInterceptor.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

internal import Alamofire
import Foundation

final class AuthRequestInterceptor: RequestInterceptor {
    private let tokenStorage: TokenStorage

    init(tokenStorage: TokenStorage) {
        self.tokenStorage = tokenStorage
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {

        Task {
            var request = urlRequest
            if let token = await tokenStorage.getToken() {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            completion(.success(request))
        }
    }
}
