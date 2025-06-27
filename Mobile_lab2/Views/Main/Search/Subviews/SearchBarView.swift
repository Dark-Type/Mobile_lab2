//
//  SearchBarView.swift
//  Mobile_lab2
//
//  Created by dark type on 27.06.2025.
//

import ComposableArchitecture
import SwiftUI

struct SearchBarView: View {
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>

    var body: some View {
        WithPerceptionTracking {
            HStack {
                HStack {
                    AppIcons.search.image
                        .renderingMode(.template)
                        .foregroundColor(.accentDark)

                    TextField("", text: viewStore.binding(get: \.searchText, send: { .binding(.set(\.searchText, $0)) }))
                        .appFont(.body)
                        .foregroundStyle(.accentDark)
                        .accessibilityIdentifier(AccessibilityIdentifiers.searchTextField.rawValue)
                        .placeholder(when: viewStore.searchText.isEmpty) {
                            Text(L10n.Search.searchViewText)
                                .appFont(.body)
                                .foregroundStyle(.accentMedium)
                        }

                    if !viewStore.searchText.isEmpty {
                        SearchClearButton(viewStore: viewStore)
                    }

                    if viewStore.isSearching {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: AppColors.accentDark.color))
                    }
                }
                .padding(SearchViewMetrics.searchBarPadding)
                .background(AppColors.white.color)
                .overlay(
                    RoundedRectangle(cornerRadius: SearchViewMetrics.cornerRadius)
                        .stroke(AppColors.accentMedium.color, lineWidth: SearchViewMetrics.strokeWidth)
                )
                .cornerRadius(SearchViewMetrics.cornerRadius)
            }
        }
    }
}

// MARK: - Clear Button

private struct SearchClearButton: View {
    let viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>

    var body: some View {
        Button(action: { viewStore.send(.clearSearchText) }, label: {
            AppIcons.close.image
                .renderingMode(.template)
                .foregroundColor(.accentDark)
        })
        .accessibilityIdentifier(AccessibilityIdentifiers.searchClearButton.rawValue)
    }
}

#Preview {
    SearchBarView(
        viewStore: ViewStore(
            Store(initialState: SearchFeature.State()) {
                SearchFeature()
            },
            observe: { $0 }
        )
    )
}
