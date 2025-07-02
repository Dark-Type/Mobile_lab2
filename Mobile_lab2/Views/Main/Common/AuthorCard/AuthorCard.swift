//
//  GenreCard 2.swift
//  Mobile_lab2
//
//  Created by dark type on 19.03.2025.
//

import SwiftUI

struct AuthorCard: View {
    // MARK: - Properties

    let author: Author

    // MARK: - Body

    var body: some View {
        HStack {
            AuthorImage(image: author.image)
            AuthorName(name: author.name)
        }
        .authorCardStyle()
    }
}

#Preview {
    AuthorCard(author: MockData.authors[0])
}
