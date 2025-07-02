//
//  LoadedImage.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

internal import Kingfisher
import SwiftUI

public struct LoadedImage {
    let url: URL
    let image: Image?
}

public protocol ImageBatchLoaderProtocol: Sendable {
    func loadImages(urls: [URL]) -> AsyncStream<LoadedImage>
}

public final class ImageBatchLoader: ImageBatchLoaderProtocol {
    private let maxConcurrentLoads: Int

    public init(maxConcurrentLoads: Int = 5) {
        self.maxConcurrentLoads = maxConcurrentLoads
    }

    public func loadImages(urls: [URL]) -> AsyncStream<LoadedImage> {
        AsyncStream { continuation in
            Task {
                var urlIterator = urls.makeIterator()
                await withTaskGroup(of: LoadedImage?.self) { group in
                    for _ in 0 ..< min(maxConcurrentLoads, urls.count) {
                        guard let url = urlIterator.next() else { break }
                        group.addTask {
                            await Self.fetchLoadedImage(for: url)
                        }
                    }
                    var completed = 0
                    while completed < urls.count {
                        guard !Task.isCancelled else { break }
                        if let loaded = await group.next() as? LoadedImage {
                            continuation.yield(loaded)
                            completed += 1
                            if let nextUrl = urlIterator.next() {
                                group.addTask {
                                    await Self.fetchLoadedImage(for: nextUrl)
                                }
                            }
                        }
                    }
                    continuation.finish()
                }
            }
        }
    }

    private static func fetchLoadedImage(for url: URL) async -> LoadedImage? {
        guard let uiImage = await fetchUIImage(for: url) else {
            return LoadedImage(url: url, image: nil)
        }
        return LoadedImage(url: url, image: Image(uiImage: uiImage))
    }

    private static func fetchUIImage(for url: URL) async -> UIImage? {
        await withCheckedContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value): continuation.resume(returning: value.image)
                case .failure: continuation.resume(returning: nil)
                }
            }
        }
    }
}
