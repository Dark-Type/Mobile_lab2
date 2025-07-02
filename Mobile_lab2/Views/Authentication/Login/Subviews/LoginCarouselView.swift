//
//  LoginCarouselView.swift
//  Mobile_lab2
//
//  Created by dark type on 26.06.2025.
//

import Perception
import SwiftUI

struct LoginCarouselView: View {
    let selectedIndex: Int

    var body: some View {
        WithPerceptionTracking {
            GeometryReader { geometry in

                let images = [MockBooks.book1.image, MockBooks.book2.image, MockBooks.book3.image]
                let itemWidth = geometry.size.width / 2.2
                let spacing: CGFloat = 5
                let totalWidth = CGFloat(images.count) * (itemWidth + spacing)

                TimelineView(.animation) { timeline in
                    WithPerceptionTracking {
                        let time = timeline.date.timeIntervalSinceReferenceDate
                        let duration: Double = 10
                        let phase = time.truncatingRemainder(dividingBy: duration) / duration
                        let offset = totalWidth * phase

                        HStack(spacing: spacing) {
                            ForEach(0..<3) { _ in
                                ForEach(0..<images.count, id: \.self) { index in
                                    CarouselImageView(
                                        image: images[index],
                                        width: itemWidth,
                                        height: geometry.size.height,
                                        index: index
                                    )
                                }
                            }
                        }
                        .offset(x: -offset)
                    }
                }
                .frame(width: geometry.size.width)
                .clipped()
            }
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.carouselView.rawValue)
    }
}

struct CarouselImageView: View {
    let image: Image
    let width: CGFloat
    let height: CGFloat
    let index: Int

    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .clipped()
            .cornerRadius(10)
            .accessibilityIdentifier("\(AccessibilityIdentifiers.carouselImage.rawValue)\(index)")
    }
}
