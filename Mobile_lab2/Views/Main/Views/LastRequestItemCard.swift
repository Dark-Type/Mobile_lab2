//
//  AuthorCard 2.swift
//  Mobile_lab2
//
//  Created by dark type on 19.03.2025.
//

import SwiftUI

struct LastRequestItemCard: View {
    let request: String
    var onDelete: () -> Void

    var body: some View {
        HStack {
            AppIcons.history.image
                .renderingMode(.template)
            Text(request)
                .appFont(.body)
            Spacer()
            Button(action: onDelete) {
                AppIcons.close.image
                    .renderingMode(.template)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .foregroundStyle(.accentDark)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.accentLight)
        .cornerRadius(12)
    }
}

#Preview {
    LastRequestItemCard(request: "Android", onDelete: {})
}
