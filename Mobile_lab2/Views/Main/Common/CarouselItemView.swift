//
//  CarouselItemView.swift
//  Mobile_lab2
//
//  Created by dark type on 21.03.2025.
//

import SwiftUI

struct CarouselItemView: View {
    // MARK: - Properties

    let book: BookUI
    let action: () -> Void

    // MARK: - Constants

    private enum ViewMetrics {
        static let cardRelativeWidth: CGFloat = 0.7
        static let cornerRadius: CGFloat = 16
        static let textSpacing: CGFloat = 8
        static let bottomPadding: CGFloat = 16
    }

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            cardContent
        }
        .buttonStyle(.plain)
    }

    // MARK: - Private Views

    private var cardContent: some View {
        ZStack(alignment: .bottom) {
            bookImage
            gradientOverlay
                .frame(width: imageWidth, height: imageWidth)
            textOverlay
                .frame(width: imageWidth, height: imageWidth, alignment: .bottom)
        }
        .cornerRadius(ViewMetrics.cornerRadius)
        .padding(.horizontal)
    }

    private var bookImage: some View {
        book.posterImage
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
                width: imageWidth,
                height: imageWidth
            )
            .clipped()
    }

    private var gradientOverlay: some View {
        LinearGradient(
            colors: [.clear, .black.opacity(0.5)],
            startPoint: .center,
            endPoint: .bottom
        )
    }

    private var textOverlay: some View {
        VStack(alignment: .leading, spacing: ViewMetrics.textSpacing) {
            Spacer()
            Text(book.description)
                .appFont(.bodySmall)
                .foregroundColor(.white)
                .lineLimit(2)
            Text(book.title.uppercased())
                .appFont(.header2)
                .foregroundColor(.white)
                .lineLimit(2)
                .padding(.bottom, ViewMetrics.bottomPadding)
        }
        .padding(.horizontal)
    }

    // MARK: - Helper Methods

    private var imageWidth: CGFloat {
        UIScreen.main.bounds.width * ViewMetrics.cardRelativeWidth
    }

    private func authorNames(_ authors: [Author]) -> String {
        authors.map(\.name).joined(separator: ", ")
    }
}

#Preview {
    CarouselItemView(book: MockData.books[0], action: {})
}
