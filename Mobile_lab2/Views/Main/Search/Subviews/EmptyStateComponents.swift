//
//  EmptyRecentSearchesView.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

import SwiftUI

// MARK: - Empty Recent Searches

struct EmptyRecentSearchesView: View {
    var body: some View {
        VStack {
            Text("No recent searches")
                .appFont(.body)
                .foregroundColor(.accentMedium)
                .multilineTextAlignment(.center)
                .padding(.vertical, 24)
        }
        .frame(maxWidth: .infinity)
        .background(AppColors.white.color.opacity(0.5))
        .cornerRadius(SearchViewMetrics.cornerRadius)
    }
}

// MARK: - Empty Genres

struct EmptyGenresView: View {
    var body: some View {
        VStack {
            Text("Жанры недоступны")
                .appFont(.body)
                .foregroundColor(.accentMedium)
                .multilineTextAlignment(.center)
                .padding(.vertical, 24)
        }
        .frame(maxWidth: .infinity)
        .background(AppColors.white.color.opacity(0.5))
        .cornerRadius(SearchViewMetrics.cornerRadius)
        .accessibilityIdentifier(AccessibilityIdentifiers.emptyGenresView.rawValue)
    }
}

// MARK: - Empty Authors

struct EmptyAuthorsView: View {
    var body: some View {
        VStack {
            Text("Авторы недоступны")
                .appFont(.body)
                .foregroundColor(.accentMedium)
                .multilineTextAlignment(.center)
                .padding(.vertical, 24)
        }
        .frame(maxWidth: .infinity)
        .background(AppColors.white.color.opacity(0.5))
        .cornerRadius(SearchViewMetrics.cornerRadius)
        .accessibilityIdentifier(AccessibilityIdentifiers.emptyAuthorsView.rawValue)
    }
}

#Preview("Empty Recent Searches") {
    EmptyRecentSearchesView()
}

#Preview("Empty Genres") {
    EmptyGenresView()
}

#Preview("Empty Authors") {
    EmptyAuthorsView()
}
