//
//  LoginView.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import SwiftUI

struct LoginView: View {
    // MARK: - State

    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var selectedCarouselIndex = 0
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    // MARK: - Computed Properties

    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    // MARK: - View

    var body: some View {
        GeometryReader { geometry in
            let layout = DeviceLayout(height: geometry.size.height)
            let topPadding = layout.topPadding(safeAreaTop: geometry.safeAreaInsets.top)
            let carouselHeight = layout.carouselHeight(totalHeight: geometry.size.height)
            let verticalSpacing = layout.verticalSpacing(totalHeight: geometry.size.height)
            let horizontalPadding = layout.horizontalPadding(totalHeight: geometry.size.height)
              
            ScrollView {
                ZStack(alignment: .top) {
                    carouselView
                        .frame(maxWidth: .infinity)
                        .frame(height: carouselHeight)
                        .padding(.top, topPadding)
                        .ignoresSafeArea(edges: .horizontal)
                      
                    VStack(spacing: verticalSpacing) {
                        Spacer()
                            .frame(height: geometry.size.height * 0.3 + geometry.safeAreaInsets.top + 20)
                          
                        titleSection
                          
                        loginForm
                          
                        loginButton
                            .padding(.top, layout.loginButtonTopPadding)
                    }
                    .padding(.horizontal, horizontalPadding)
                    .ignoresSafeArea(edges: .horizontal)
                }
            }
        }
    }
      
    // MARK: - Subviews

    private var carouselView: some View {
        GeometryReader { geometry in
            let images = [MockBooks.book1.image, MockBooks.book2.image, MockBooks.book3.image]
            let itemWidth = (geometry.size.width) / 2.2
            let spacing: CGFloat = 5
            
            let totalWidth = CGFloat(images.count) * (itemWidth + spacing)
            
            ZStack {
                HStack(spacing: spacing) {
                    ForEach(0..<3) { _ in
                        ForEach(0..<images.count, id: \.self) { index in
                            images[index]
                                .resizable()
                                .scaledToFit()
                                .frame(width: itemWidth, height: geometry.size.height)
                                .clipped()
                                .cornerRadius(10)
                        }
                    }
                }
              
                .modifier(ContinuousScrollModifier(
                    itemWidth: itemWidth + spacing,
                    totalWidth: totalWidth
                ))
            }
            .frame(width: geometry.size.width)
            .clipped()
        }
        .frame(height: 300)
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(L10n.Login.Title.first.uppercased())
                .appFont(AppFont.h1)
                .foregroundStyle(AppColors.accentLight)
                .lineSpacing(1)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, -10)

            Text(L10n.Login.Title.second.uppercased())
                .font(.custom(AppFont.title.name, size: AppFont.title.size))
                .foregroundStyle(AppColors.secondary)
                .lineSpacing(1)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, -20)

            Text(L10n.Login.Title.third.uppercased())
                .font(.custom(AppFont.title.name, size: AppFont.title.size))
                .foregroundStyle(AppColors.secondary)
                .lineSpacing(1)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, -20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var loginForm: some View {
        VStack(spacing: 0) {
            enhancedTextField(
                placeholder: L10n.Login.email,
                text: $email,
                showClearButton: !email.isEmpty,
                clearAction: { email = "" }
            )
                
            enhancedSecureField(
                placeholder: L10n.Login.password,
                text: $password,
                isVisible: $isPasswordVisible,
                showClearButton: !password.isEmpty,
                clearAction: { password = "" }
            )
        }
        .applyOutlinedFieldStyle()
    }

    private func enhancedTextField(
        placeholder: String,
        text: Binding<String>,
        showClearButton: Bool,
        clearAction: @escaping () -> Void
    ) -> some View {
        HStack(spacing: 0) {
            Text(placeholder)
                .foregroundColor(AppColors.accentMedium.color)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 16)
                .appFont(.bodySmall)
                .padding(.vertical, 16)
                
            TextField("", text: text)
                
                .foregroundColor(AppColors.accentLight.color)
                .appFont(.bodySmall)
                    
            if showClearButton {
                Button(action: clearAction) {
                    AppIcons.close.image
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(AppColors.accentLight.color)
                        .frame(width: 24, height: 24)
                }
                .padding(.trailing, 16)
            } else {
                Spacer()
                    .frame(width: 16)
            }
        }
    }
       
    private func enhancedSecureField(
        placeholder: String,
        text: Binding<String>,
        isVisible: Binding<Bool>,
        showClearButton: Bool,
        clearAction: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 0) {
            Divider()
                .background(AppColors.accentMedium.color)
                .padding(.leading, 16)
            
            HStack(spacing: 0) {
                Text(placeholder)
                    .foregroundColor(AppColors.accentMedium.color)
                    .frame(width: 100, alignment: .leading)
                    .padding(.leading, 16)
                    .appFont(.bodySmall)
                    .padding(.vertical, 16)
                
                Group {
                    if isVisible.wrappedValue {
                        TextField("", text: text)
                            .foregroundStyle(.accentLight)
                            .appFont(AppFont.bodySmall)
                            
                    } else {
                        SecureField("", text: text)
                            .foregroundStyle(.accentLight)
                            .appFont(.bodySmall)
                    }
                }
                
                if !text.wrappedValue.isEmpty {
                    Button(action: { isVisible.wrappedValue.toggle() }) {
                        (isVisible.wrappedValue ? AppIcons.eyeOn : AppIcons.eyeOff).image
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(AppColors.accentLight.color)
                            .frame(width: 24, height: 24)
                    }
                    .padding(.trailing, 16)
                    
                } else {
                    Spacer()
                        .frame(width: 16)
                }
            }
            
            .background(.clear)
        }
    }

    private var loginButton: some View {
        Button(action: login) {
            Text(L10n.Login.button)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isFormValid ? AppColors.white.color : AppColors.accentMedium.color)
                .foregroundColor(isFormValid ? AppColors.accentDark.color : AppColors.white.color)
                .cornerRadius(10)
        }
        .disabled(!isFormValid)
    }
    
    // MARK: - Actions

    private func login() {
        withAnimation {
            isLoggedIn = true
        }
    }
}

// MARK: - View Modifiers

struct OutlinedFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColors.accentMedium.color, lineWidth: 1)
            )
    }
}

struct TitleTextModifier: ViewModifier {
    let fontSize: CGFloat
    let weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: weight))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ContinuousScrollModifier: ViewModifier {
    let itemWidth: CGFloat
    let totalWidth: CGFloat
    
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(x: -offset)
            .onAppear {
                withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                    offset = totalWidth
                }
            }
    }
}

// MARK: - View Extensions

extension View {
    func applyOutlinedFieldStyle() -> some View {
        modifier(OutlinedFieldModifier())
    }
    
    func applyTitleStyle(fontSize: CGFloat, weight: Font.Weight) -> some View {
        modifier(TitleTextModifier(fontSize: fontSize, weight: weight))
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Preview

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
