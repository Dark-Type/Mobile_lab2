//
//  LibraryView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct LibraryScreen: View {
    private let featuredBooks = MockData.books
    private var initialItems: [Book] = []
    
    @State private var carouselItems: [UUID: Book] = [:]
    @State private var itemKeys: [UUID] = []
    @State private var currentIndex: Int = 0
    @State private var selectedBook: Book? = nil
    @State private var showingBookDetail = false
    
    init() {
        var initialCarouselItems: [UUID: Book] = [:]
        var initialKeys: [UUID] = []
        
        for _ in 0 ..< 4 {
            for book in MockData.books {
                let id = UUID()
                initialCarouselItems[id] = book
                initialKeys.append(id)
            }
        }
        
        _carouselItems = State(initialValue: initialCarouselItems)
        _itemKeys = State(initialValue: initialKeys)
    }
    
    var body: some View {
        GeometryReader { screenGeometry in
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(L10n.Library.title.uppercased())
                            .appFont(.h1)
                            .foregroundColor(.secondaryRed)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(L10n.Library.new.uppercased())
                                .appFont(.h2)
                                .foregroundColor(.accentDark)
                                .padding(.horizontal)
                            
                            carouselView(screenHeight: screenGeometry.size.height)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(L10n.Library.popular.uppercased())
                                .appFont(.h2)
                                .foregroundColor(.accentDark)
                                .padding(.horizontal)
                            
                            booksGridView(screenWidth: screenGeometry.size.width)
                        }
                        .padding(.bottom, 24)
                    }
                    .padding(.top, 16)
                }
                .scrollContentBackground(.hidden)
                .background(AppColors.background.color)
                .onChange(of: showingBookDetail) { newValue in
                    if newValue == false {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            selectedBook = nil
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.hidden, for: .navigationBar)
                .navigationDestination(isPresented: $showingBookDetail) {
                    if let book = selectedBook {
                        ReadingScreen(book: book)
                            .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func openBookDetail(_ book: Book) {
        selectedBook = book
        showingBookDetail = true
    }
    
    private func carouselView(screenHeight: CGFloat) -> some View {
        let itemWidth = UIScreen.main.bounds.width * 0.7
        let itemHeight = itemWidth
        let sideItemWidth = UIScreen.main.bounds.width * 0.12
        let spacing: CGFloat = 20
        
        return ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(itemKeys, id: \.self) { key in
                        if let book = carouselItems[key] {
                            CarouselItemView(book: book) {
                                openBookDetail(book)
                            }
                            .id(key)
                            .frame(width: itemWidth, height: itemHeight)
                        }
                    }
                }
                .padding(.horizontal, sideItemWidth)
            }
            .onAppear {
                scrollView.scrollTo(itemKeys[itemKeys.count / 2], anchor: .center)
            }
            .background(
                GeometryReader { geometry -> Color in
                    let minX = geometry.frame(in: .global).minX
                    DispatchQueue.main.async {
                        handleScrollChange(minX: minX)
                    }
                    return Color.clear
                }
            )
        }
        .frame(height: itemHeight + 16)
    }
    
    private func booksGridView(screenWidth: CGFloat) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
            spacing: 20
        ) {
            ForEach(MockData.books) { book in
                BookCard(
                    book: book,
                    width: (screenWidth - 64) / 3,
                    height: 220,
                    action: {
                        openBookDetail(book)
                    }
                )
            }
        }
        .background(Color.clear)
        .padding(.horizontal)
    }
    
    private func handleScrollChange(minX: CGFloat) {
        let threshold: CGFloat = UIScreen.main.bounds.width * 1.5
        
        if minX > -threshold && currentIndex > 0 {
            insertItemsAtStart()
            currentIndex -= MockData.books.count
        }
        
        if minX < -threshold * 3 && currentIndex < itemKeys.count - MockData.books.count {
            appendItemsAtEnd()
        }
    }
    
    private func insertItemsAtStart() {
        var newItems: [UUID: Book] = [:]
        var newKeys: [UUID] = []
        
        for book in MockData.books {
            let id = UUID()
            newItems[id] = book
            newKeys.append(id)
        }
        
        carouselItems.merge(newItems) { _, new in new }
        itemKeys.insert(contentsOf: newKeys, at: 0)
    }
    
    private func appendItemsAtEnd() {
        var newItems: [UUID: Book] = [:]
        var newKeys: [UUID] = []
        
        for book in MockData.books {
            let id = UUID()
            newItems[id] = book
            newKeys.append(id)
        }
        
        carouselItems.merge(newItems) { _, new in new }
        itemKeys.append(contentsOf: newKeys)
    }
}

#Preview {
    LibraryScreen()
}
