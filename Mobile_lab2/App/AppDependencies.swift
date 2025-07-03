//
//  AppDependencies.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import Alamofire
import ComposableArchitecture
import Foundation
import Networking

let tokenStorage: TokenStorage = UserDefaultsTokenStorage()

let baseURL = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as! String

let authSession = Session(configuration: {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 70
    config.timeoutIntervalForResource = 70
    return config
}())

let authService = AuthService(session: authSession, baseURL: baseURL)
let authRepository = AuthRepository(service: authService, tokenStorage: tokenStorage)

let authRequestInterceptor = AuthRequestInterceptor(
    tokenStorage: tokenStorage,
    authRepository: authRepository,
    refreshRequestProvider: { nil }
)

let authenticatedSession = Session(configuration: {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 70
    config.timeoutIntervalForResource = 70
    return config
}(), interceptor: authRequestInterceptor)

let bookService = BookService(session: authenticatedSession, baseURL: baseURL)
let chapterService = ChapterService(session: authenticatedSession, baseURL: baseURL)
let favoriteService = FavoriteService(session: authenticatedSession, baseURL: baseURL)
let progressService = ProgressService(session: authenticatedSession, baseURL: baseURL)
let quoteService = QuoteService(session: authenticatedSession, baseURL: baseURL)
let referenceDataService = ReferenceDataService(session: authenticatedSession, baseURL: baseURL)

let bookRepository = BookRepository(service: bookService)
let chapterRepository = ChapterRepository(service: chapterService)
let favoriteRepository = FavoriteRepository(service: favoriteService)
let progressRepository = ProgressRepository(service: progressService)
let quoteRepository = QuoteRepository(service: quoteService)
let referenceDataRepository = ReferenceDataRepository(service: referenceDataService)

let imageBatchLoader = ImageBatchLoader()

extension AuthRepository: @retroactive TestDependencyKey {}
extension AuthRepository: @retroactive DependencyKey {
    public typealias Value = any AuthRepositoryProtocol
    public static let liveValue: any AuthRepositoryProtocol = authRepository
}

extension UserDefaultsTokenStorage: @retroactive DependencyKey {
    public typealias Value = any TokenStorage
    public static let liveValue: any TokenStorage = tokenStorage
}

extension BookRepository: @retroactive TestDependencyKey {}
extension BookRepository: @retroactive DependencyKey {
    public typealias Value = any BookRepositoryProtocol
    public static let liveValue: any BookRepositoryProtocol = bookRepository
}

extension ChapterRepository: @retroactive TestDependencyKey {}
extension ChapterRepository: @retroactive DependencyKey {
    public typealias Value = any ChapterRepositoryProtocol
    public static let liveValue: any ChapterRepositoryProtocol = chapterRepository
}

extension FavoriteRepository: @retroactive TestDependencyKey {}
extension FavoriteRepository: @retroactive DependencyKey {
    public typealias Value = any FavoriteRepositoryProtocol
    public static let liveValue: any FavoriteRepositoryProtocol = favoriteRepository
}

extension ProgressRepository: @retroactive TestDependencyKey {}
extension ProgressRepository: @retroactive DependencyKey {
    public typealias Value = any ProgressRepositoryProtocol
    public static let liveValue: any ProgressRepositoryProtocol = progressRepository
}

extension QuoteRepository: @retroactive TestDependencyKey {}
extension QuoteRepository: @retroactive DependencyKey {
    public typealias Value = any QuoteRepositoryProtocol
    public static let liveValue: any QuoteRepositoryProtocol = quoteRepository
}

extension ReferenceDataRepository: @retroactive TestDependencyKey {}
extension ReferenceDataRepository: @retroactive DependencyKey {
    public typealias Value = any ReferenceDataRepositoryProtocol
    public static let liveValue: any ReferenceDataRepositoryProtocol = referenceDataRepository
}

extension ImageBatchLoader: @retroactive DependencyKey {
    public typealias Value = any ImageBatchLoaderProtocol
    public static let liveValue: any ImageBatchLoaderProtocol = imageBatchLoader
}

public extension DependencyValues {
    var authRepository: AuthRepositoryProtocol {
        get { self[AuthRepository.self] }
        set { self[AuthRepository.self] = newValue }
    }

    var bookRepository: BookRepositoryProtocol {
        get { self[BookRepository.self] }
        set { self[BookRepository.self] = newValue }
    }

    var chapterRepository: ChapterRepositoryProtocol {
        get { self[ChapterRepository.self] }
        set { self[ChapterRepository.self] = newValue }
    }

    var favoriteRepository: FavoriteRepositoryProtocol {
        get { self[FavoriteRepository.self] }
        set { self[FavoriteRepository.self] = newValue }
    }

    var progressRepository: ProgressRepositoryProtocol {
        get { self[ProgressRepository.self] }
        set { self[ProgressRepository.self] = newValue }
    }

    var quoteRepository: QuoteRepositoryProtocol {
        get { self[QuoteRepository.self] }
        set { self[QuoteRepository.self] = newValue }
    }

    var referenceDataRepository: ReferenceDataRepositoryProtocol {
        get { self[ReferenceDataRepository.self] }
        set { self[ReferenceDataRepository.self] = newValue }
    }

    var imageBatchLoader: ImageBatchLoaderProtocol {
        get { self[ImageBatchLoader.self] }
        set { self[ImageBatchLoader.self] = newValue }
    }

    var tokenStorage: TokenStorage {
        get { self[UserDefaultsTokenStorage.self] }
        set { self[UserDefaultsTokenStorage.self] = newValue }
    }
}
