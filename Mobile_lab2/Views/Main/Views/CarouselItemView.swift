//
//  CarouselItemView.swift
//  Mobile_lab2
//
//  Created by dark type on 21.03.2025.
//

import SwiftUI

struct CarouselItemView: View {
    let book: Book
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottom) {
                book.posterImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.7)
                    .clipped()
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0),
                        Color.black.opacity(0.5)
                    ]),
                    startPoint: .center,
                    endPoint: .bottom
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    
                    Text(book.description)
                        .appFont(.bodySmall)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        
                    Text(book.title.uppercased())
                        .appFont(.h2)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .padding(.bottom, 16)
                }
            }
         
            .cornerRadius(16)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func authorNames(_ authors: [Author]) -> String {
        return authors.map { $0.name }.joined(separator: ", ")
    }
}

#Preview {
    CarouselItemView(book: MockData.books[0], action: {})
}
