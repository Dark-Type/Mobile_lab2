//
//  BookAuthorsSection.swift
//  Mobile_lab2
//
//  Created by dark type on 03.07.2025.
//

import SwiftUI

struct BookAuthorsSection: View {
    let authors: [Author]
    let width: CGFloat

    private enum ViewMetrics {
        static let maxAuthorsShown: Int = 2
        static let lineHeightMultiple: CGFloat = 1.0
        static let textOpacity: CGFloat = 0.7
    }

    private var shouldShowAdditionalAuthorsLabel: Bool {
        authors.count > ViewMetrics.maxAuthorsShown
    }

    private var visibleAuthors: [Author] {
        Array(authors.prefix(ViewMetrics.maxAuthorsShown))
    }

    private var additionalAuthorsCount: Int {
        authors.count - ViewMetrics.maxAuthorsShown
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !authors.isEmpty {
                ForEach(visibleAuthors.indices, id: \.self) { index in
                    BookCardAuthorLabel(author: visibleAuthors[index], width: width)
                }

                if shouldShowAdditionalAuthorsLabel {
                    BookCardAdditionalAuthorsLabel(count: additionalAuthorsCount, width: width)
                }
            }
        }
    }
}
