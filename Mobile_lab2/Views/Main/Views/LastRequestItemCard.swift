//
//  AuthorCard 2.swift
//  Mobile_lab2
//
//  Created by dark type on 19.03.2025.
//

import SwiftUI

struct LastRequestItemCard: View {
    // MARK: - Properties
    let request: String
    var onDelete: () -> Void
    
    // MARK: - Constants
    private enum ViewMetrics {
        static let padding: CGFloat = 16
        static let cornerRadius: CGFloat = 12
    }
    
    // MARK: - Body
    var body: some View {
        cardContent
    }
    
    // MARK: - Private Views
    private var cardContent: some View {
        HStack {
            historyIcon
            requestText
            Spacer()
            deleteButton
        }
        .foregroundStyle(.accentDark)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(ViewMetrics.padding)
        .background(.accentLight)
        .cornerRadius(ViewMetrics.cornerRadius)
    }
    
    private var historyIcon: some View {
        AppIcons.history.image
            .renderingMode(.template)
    }
    
    private var requestText: some View {
        Text(request)
            .appFont(.body)
    }
    
    private var deleteButton: some View {
        Button(action: onDelete) {
            AppIcons.close.image
                .renderingMode(.template)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LastRequestItemCard(request: "Android", onDelete: {})
}
