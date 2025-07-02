//
//  RefreshState.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//
internal import Alamofire

actor RefreshState {
    private var isRefreshing = false
    private var continuations: [CheckedContinuation<RetryResult, Never>] = []

    func waitForRefresh() async -> RetryResult {
        await withCheckedContinuation { continuation in
            continuations.append(continuation)
        }
    }

    func shouldStartRefresh() -> Bool {
        if !isRefreshing {
            isRefreshing = true
            return true
        }
        return false
    }

    func completeAll(_ result: RetryResult) {
        continuations.forEach { $0.resume(returning: result) }
        continuations.removeAll()
        isRefreshing = false
    }
}
