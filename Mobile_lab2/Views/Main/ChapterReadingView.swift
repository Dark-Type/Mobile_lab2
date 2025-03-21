//
//  ChapterReadingView.swift
//  Mobile_lab2
//
//  Created by dark type on 19.03.2025.
//

import SwiftUI

import SwiftUI

struct ChapterReadingView: View {
    // MARK: - Properties
    
    let book: Book
    let setCurrentBook: (Book) -> Void
    let chapter: Chapter
    @Environment(\.dismiss) private var dismiss
    @State private var showChapters: Bool = false
    @State private var showSettings: Bool = false
    @State private var isAutoScrolling: Bool = false
    @State private var fontSize: CGFloat = 14
    @State private var lineSpacing: CGFloat = 6
    @State private var showQuoteOverlay: Bool = false
    @State private var selectedText: String = ""
    
    // MARK: - View
    
    var body: some View {
        ZStack(alignment: .bottom) {
            self.mainContentView
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: AppColors.background.color.opacity(0), location: 0),
                                .init(color: AppColors.background.color, location: 1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 100)
                    .allowsHitTesting(false)
                self.chapterTabBar
            }
            .ignoresSafeArea(.all, edges: .bottom)
            
            if self.showChapters {
                self.chaptersOverlay
            }
            
            if self.showSettings {
                self.settingsOverlay
            }
            
            if self.showQuoteOverlay {
                self.quoteSelectionOverlay
            }
        }.onAppear {
            setCurrentBook(book)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            self.leadingToolbarItem
            self.principalToolbarItem
        }
        .toolbarBackground(AppColors.background.color, for: .navigationBar)
        .toolbar(self.showChapters || self.showSettings || self.showQuoteOverlay ? .hidden : .automatic, for: .navigationBar)
        .background(AppColors.background.color)
    }
    
    // MARK: - Content Views
    
    private var mainContentView: some View {
        ScrollView(showsIndicators: false) {
            self.chapterContentView
                .padding(.horizontal, 16)
                .padding(.bottom, 120)
        }
    }
    
    private var chapterContentView: some View {
        let readingFont = AppFont.text.withReadingSettings(
            fontSize: self.fontSize,
            lineSpacing: self.lineSpacing
        )
               
        return Text(self.chapter.content)
            .readingFont(readingFont)
            .padding(.top, 24)
    }
    
    // MARK: - Toolbar Items
    
    private var leadingToolbarItem: ToolbarItem<Void, some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: { self.dismiss() }) {
                HStack {
                    AppIcons.arrowLeft.image
                        .renderingMode(.template)
                    Text(L10n.Book.goBack)
                }.foregroundColor(.accentDark)
            }
        }
    }
    
    private var principalToolbarItem: ToolbarItem<Void, some View> {
        ToolbarItem(placement: .principal) {
            VStack {
                Text(self.book.title)
                    .appFont(.h2)
                
                Text(self.chapter.title)
                    .appFont(.bodySmall)
            }
            .foregroundStyle(.accentDark)
        }
    }
    
    // MARK: - Tab Bar and Buttons
    
    private func customIconButton(icon: Image, action: @escaping () -> Void) -> some View {
        if icon == AppIcons.play.image || icon == AppIcons.pause.image {
            return AnyView(
                Button(action: action) {
                    ZStack {
                        Circle()
                            .fill(AppColors.accentLight.color)
                            .frame(width: 52, height: 52)
                        icon
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .foregroundColor(AppColors.accentDark.color)
                    }.padding(.top, 16)
                        .padding(.trailing, 16)
                }.buttonStyle(NoFadeButtonStyle())
            )
        } else {
            return AnyView(
                Button(action: action) {
                    icon
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            )
        }
    }
    
    private var chapterTabBar: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                self.customIconButton(icon: AppIcons.previous.image, action: {
                    // TODO: implement navigation between chapters
                })
                
                self.customIconButton(icon: AppIcons.contents.image, action: {
                    withAnimation {
                        self.showChapters.toggle()
                    }
                })
                
                self.customIconButton(icon: AppIcons.next.image, action: {
                    // TODO: implement navigation between chapters
                })
                
                self.customIconButton(icon: AppIcons.settings.image, action: {
                    withAnimation {
                        self.showSettings.toggle()
                    }
                })
            }.padding(.leading, 8)
            
            self.customIconButton(icon: self.isAutoScrolling ? AppIcons.pause.image : AppIcons.play.image, action: {
                withAnimation {
                    self.isAutoScrolling.toggle()
                }
            })
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .foregroundColor(AppColors.white.color)
        .background(AppColors.accentDark.color)
    }
    
    // MARK: - Overlays
    
    var chaptersOverlay: some View {
        GeometryReader { geometry in
            self.bottomOverlay {
                VStack(spacing: 0) {
                    self.overlayDragIndicator
                    
                    self.overlayTitle(L10n.Book.contents, action: {
                        withAnimation {
                            self.showChapters = false
                        }
                    })
                    Divider()
                        .foregroundStyle(AppColors.accentLight.color)
                    
                    self.chaptersListView
                }
            }
            .frame(height: geometry.size.height)
            .transition(.move(edge: .bottom))
            .zIndex(1)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.height > 100 {
                            withAnimation {
                                self.showChapters = false
                            }
                        }
                    }
            )
        }
    }
    
    var settingsOverlay: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                   
                VStack(spacing: 16) {
                    self.overlaySettingsTitle(L10n.Book.Settings.title, action: {
                        withAnimation {
                            self.showSettings = false
                        }
                    })
                       
                    self.fontSizeControl
                        
                    self.lineSpacingControl
                       
                    Spacer(minLength: 16)
                }
                .padding(.top, 32)
                .padding(.horizontal, 16)
                .frame(height: min(350, geometry.size.height * 0.35))
                .background(AppColors.background.color)
                .cornerRadius(8, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    
        .transition(.move(edge: .bottom))
        .zIndex(1)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 50 {
                        withAnimation {
                            self.showSettings = false
                        }
                    }
                }
        )
    }
    
    private func bottomOverlay<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            Spacer()
            
            content()
                .background(AppColors.background.color)
                .cornerRadius(16, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    // MARK: - Inner Components
    
    var chaptersListView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(self.book.chapters) { chapter in
                    ChapterListItem(chapter: chapter) {
                        withAnimation {
                            self.showChapters = false
                            // TODO: setup opening chapters
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
    }
    
    var fontSizeControl: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(L10n.Book.Settings.font)
                .appFont(.body)
                .foregroundStyle(.accentDark)
            
            HStack(spacing: 0) {
                Text("\(Int(self.fontSize)) " + L10n.Book.Settings.measure)
                    .appFont(.body)
                    .foregroundStyle(.accentDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                
                HStack(spacing: 0) {
                    Button(action: {
                        if self.fontSize > 14 {
                            self.fontSize -= 2
                        }
                    }) {
                        Image(systemName: "minus")
                            .foregroundStyle(.accentDark)
                            .frame(width: 47, height: 32)
                    }
                    
                    Rectangle()
                        .fill(.accentMedium)
                        .frame(width: 1, height: 18)
                    
                    Button(action: {
                        if self.fontSize < 24 {
                            self.fontSize += 2
                        }
                    }) {
                        Image(systemName: "plus")
                            .foregroundStyle(.accentDark)
                            .frame(width: 47, height: 32)
                    }
                }
                .background(AppColors.accentLight.color)
                .cornerRadius(10)
            }
        }
    }
    
    var lineSpacingControl: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(L10n.Book.Settings.padding)
                .appFont(.body)
                .foregroundStyle(.accentDark)
            
            HStack(spacing: 0) {
                Text("\(Int(self.lineSpacing)) " + L10n.Book.Settings.measure)
                    .appFont(.body)
                    .foregroundStyle(.accentDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                
                HStack(spacing: 0) {
                    Button(action: {
                        if self.lineSpacing > 4 {
                            self.lineSpacing -= 2
                        }
                    }) {
                        Image(systemName: "minus")
                            .foregroundStyle(.accentDark)
                            .frame(width: 47, height: 32)
                    }
                    
                    Rectangle()
                        .fill(.accentMedium)
                        .frame(width: 1, height: 18)
                    
                    Button(action: {
                        if self.lineSpacing < 12 {
                            self.lineSpacing += 2
                        }
                    }) {
                        Image(systemName: "plus")
                            .foregroundStyle(.accentDark)
                            .frame(width: 47, height: 32)
                    }
                }
                .background(AppColors.accentLight.color)
                .cornerRadius(10)
            }
        }
    }

    // TODO: implement the quote selection.
    private var quoteSelectionOverlay: some View {
        VStack(spacing: 20) {
            Text(self.selectedText)
                .font(.system(size: 16, weight: .medium, design: .serif))
                .padding(16)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            
            HStack(spacing: 16) {
                Button {
                    withAnimation {
                        self.showQuoteOverlay = false
                        self.selectedText = ""
                    }
                } label: {
                    Text("Отмена")
                        .applyButtonStyle(backgroundColor: AppColors.background.color)
                }
                
                Button {
                    withAnimation {
                        self.showQuoteOverlay = false
                        self.selectedText = ""
                    }
                } label: {
                    Text("Добавить в цитаты")
                        .applyButtonStyle(foregroundColor: .white, backgroundColor: AppColors.accentLight.color)
                }
            }
        }
        .padding(20)
    }
    
    // MARK: - Helper Views

    private var overlayDragIndicator: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(Color.gray.opacity(0.5))
            .frame(width: 40, height: 5)
            .padding(.vertical, 10)
    }
    
    private func overlayTitle(_ title: String, action: @escaping () -> Void) -> some View {
        ZStack {
            HStack {
                Button(action: action) {
                    HStack {
                        AppIcons.arrowLeft.image
                            .renderingMode(.template)
                            
                        Text(L10n.Book.goBack)
                    }
                }
                
                Spacer()
            }
            .padding(.leading)
            
            Text(title.uppercased())
                .appFont(.h2)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .foregroundColor(.accentDark)
        .padding(.bottom, 8)
    }

    private func overlaySettingsTitle(_ title: String, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .appFont(.h2)
                
            Spacer()
            Button(action: action) {
                AppIcons.close.image
                    .renderingMode(.template)
            }
        }.foregroundColor(.accentDark)
    }
    
    private func overlayActionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .applyButtonStyle(
                    foregroundColor: .white,
                    backgroundColor: AppColors.accentLight.color
                )
        }
    }
    
    private func sizeControlButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .frame(width: 44, height: 44)
                .background(AppColors.accentLight.color)
                .cornerRadius(8)
        }
    }
}

// MARK: - View Extensions

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func applyButtonStyle(
        foregroundColor: Color = .primary,
        backgroundColor: Color = AppColors.accentLight.color
    ) -> some View {
        self
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(backgroundColor)
            .cornerRadius(10)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    NavigationStack {
        ChapterReadingView(
            book: MockData.books[0],
            setCurrentBook: { _ in } ,
            chapter: MockData.books[0].chapters[1]
            
        )
    }
}
