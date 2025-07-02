//
//  NetworkStatus.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import ComposableArchitecture
import Network

enum NetworkStatus: Equatable {
    case connected
    case disconnected
}

struct NetworkStatusClient: Sendable {
    var observe: @Sendable () -> AsyncStream<NetworkStatus>
}

extension NetworkStatusClient: DependencyKey {
    static let liveValue = NetworkStatusClient(
        observe: {
            AsyncStream { continuation in
                let monitor = NWPathMonitor()
                let queue = DispatchQueue(label: "NetworkMonitor")
                monitor.pathUpdateHandler = { path in
                    let status: NetworkStatus = path.status == .satisfied ? .connected : .disconnected
                    continuation.yield(status)
                }
                monitor.start(queue: queue)
                continuation.onTermination = { _ in
                    monitor.cancel()
                }
            }
        }
    )
}

extension DependencyValues {
    var networkStatus: NetworkStatusClient {
        get { self[NetworkStatusClient.self] }
        set { self[NetworkStatusClient.self] = newValue }
    }
}
