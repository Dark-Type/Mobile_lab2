//
//  LibraryView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct LibraryScreen: View {
    // MARK: - Constants
    
    private enum ViewMetrics {
        static let verticalSpacing: CGFloat = 24
        static let sectionSpacing: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 24
        static let gridSpacing: CGFloat = 20
        static let gridItemSpacing: CGFloat = 16
        static let gridColumnsCount: Int = 3
        static let carouselItemScale: CGFloat = 0.7
        static let carouselSideItemScale: CGFloat = 0.12
        static let carouselSpacing: CGFloat = 20
        static let carouselHeightPadding: CGFloat = 16
        static let scrollThresholdMultiplier: CGFloat = 1.5
        static let scrollThresholdEndMultiplier: CGFloat = 3
    }
    
    // MARK: - Properties
    
    private let featuredBooks = MockData.books
    private var initialItems: [Book] = []
    let isFavorite: (Book) -> Bool
    let setCurrentBook: (Book) -> Void
    let toggleFavorite: (Book) -> Void
    
    @State private var carouselItems: [UUID: Book] = [:]
    @State private var itemKeys: [UUID] = []
    @State private var currentIndex: Int = 0
    @State private var selectedBook: Book? = nil
    
    // MARK: - Initialization
    
    init(
        isFavorite: @escaping (Book) -> Bool,
        setCurrentBook: @escaping (Book) -> Void = { _ in },
        toggleFavorite: @escaping (Book) -> Void = { _ in }
    ) {
        self.isFavorite = isFavorite
        self.setCurrentBook = setCurrentBook
        self.toggleFavorite = toggleFavorite
        
        // Initialize carousel with repeated books
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
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { screenGeometry in
            ScrollView {
                VStack(alignment: .leading, spacing: ViewMetrics.verticalSpacing) {
                    headerView
                    newBooksSection(screenHeight: screenGeometry.size.height)
                    popularBooksSection(screenWidth: screenGeometry.size.width)
                }
                .padding(.top, ViewMetrics.topPadding)
            }
            .scrollContentBackground(.hidden)
            .background(AppColors.background.color)
            .fullScreenCover(item: $selectedBook) { book in
                NavigationStack {
                    ReadingScreen(
                        book: book,
                        setCurrentBook: setCurrentBook,
                        isFavorite: isFavorite(book),
                        toggleFavorite: { toggleFavorite(book) }
                    )
                    .toolbarBackground(Color.clear, for: .navigationBar)
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerView: some View {
        Text(L10n.Library.title.uppercased())
            .appFont(.h1)
            .foregroundColor(.secondaryRed)
            .padding(.horizontal, ViewMetrics.horizontalPadding)
    }
    
    private func newBooksSection(screenHeight: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: ViewMetrics.sectionSpacing) {
            Text(L10n.Library.new.uppercased())
                .appFont(.h2)
                .foregroundColor(.accentDark)
                .padding(.horizontal, ViewMetrics.horizontalPadding)
            
            carouselView(screenHeight: screenHeight)
        }
    }
    
    private func popularBooksSection(screenWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: ViewMetrics.sectionSpacing) {
            Text(L10n.Library.popular.uppercased())
                .appFont(.h2)
                .foregroundColor(.accentDark)
                .padding(.horizontal, ViewMetrics.horizontalPadding)
            
            booksGridView(screenWidth: screenWidth)
        }
        .padding(.bottom, ViewMetrics.bottomPadding)
    }
    
    private func carouselView(screenHeight: CGFloat) -> some View {
        let itemWidth = UIScreen.main.bounds.width * ViewMetrics.carouselItemScale
        let itemHeight = itemWidth
        let sideItemWidth = UIScreen.main.bounds.width * ViewMetrics.carouselSideItemScale
        
        return ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ViewMetrics.carouselSpacing) {
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
        .frame(height: itemHeight + ViewMetrics.carouselHeightPadding)
    }
    
    private func booksGridView(screenWidth: CGFloat) -> some View {
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: ViewMetrics.gridItemSpacing),
            count: ViewMetrics.gridColumnsCount
        )
        
        return LazyVGrid(columns: columns, spacing: ViewMetrics.gridSpacing) {
            ForEach(MockData.books) { book in
                BookCard(
                    book: book,
                    width: (screenWidth - (ViewMetrics.horizontalPadding * 2) -
                        (ViewMetrics.gridItemSpacing * CGFloat(ViewMetrics.gridColumnsCount - 1))) /
                        CGFloat(ViewMetrics.gridColumnsCount),
                    height: 270,
                    action: {
                        openBookDetail(book)
                    }
                )
            }
        }
        .background(Color.clear)
        .padding(.horizontal, ViewMetrics.horizontalPadding)
    }
    
    // MARK: - Helper Methods
    
    private func openBookDetail(_ book: Book) {
        selectedBook = book
    }
    
    private func handleScrollChange(minX: CGFloat) {
        let threshold: CGFloat = UIScreen.main.bounds.width * ViewMetrics.scrollThresholdMultiplier
        
        if minX > -threshold && currentIndex > 0 {
            insertItemsAtStart()
            currentIndex -= MockData.books.count
        }
        
        if minX < -threshold * ViewMetrics.scrollThresholdEndMultiplier &&
            currentIndex < itemKeys.count - MockData.books.count
        {
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
    LibraryScreen(
        isFavorite: { _ in false }
    )
}
