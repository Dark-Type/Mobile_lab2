//
//  RefreshState.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//
import Alamofire

public actor RefreshState {
    private var isRefreshing = false
    private var continuations: [CheckedContinuation<RetryResult, Never>] = []

    public func waitForRefresh() async -> RetryResult {
        await withCheckedContinuation { continuation in
            continuations.append(continuation)
        }
    }

    public func shouldStartRefresh() -> Bool {
        if !isRefreshing {
            isRefreshing = true
            return true
        }
        return false
    }

    public func completeAll(_ result: RetryResult) {
        continuations.forEach { $0.resume(returning: result) }
        continuations.removeAll()
        isRefreshing = false
    }
}
