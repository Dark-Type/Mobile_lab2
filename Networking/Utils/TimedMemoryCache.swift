//
//  TimedMemoryCache.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import Foundation

actor TimedMemoryCache<Key: Hashable & Sendable, Value: Sendable> {
    private var cache: [Key: (expiry: Date, value: Value)] = [:]
    private let lifetime: TimeInterval

    init(lifetime: TimeInterval) {
        self.lifetime = lifetime
    }

    func value(for key: Key) async -> Value? {
        if let item = cache[key], item.expiry > Date() {
            return item.value
        } else {
            cache[key] = nil
            return nil
        }
    }

    func set(_ value: Value, for key: Key) async {
        cache[key] = (expiry: Date().addingTimeInterval(lifetime), value: value)
    }

    func clear() async {
        cache.removeAll()
    }
}
