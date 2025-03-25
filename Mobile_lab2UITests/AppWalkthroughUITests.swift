//
//  AppWalkthroughUITests.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import XCTest

class AppWalkthroughUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        
        app.launchArguments = ["-ui-testing-logged-out", "-UITestMode"]
        app.terminate()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
    }
    
    func testFullAppWalkthrough() throws {
        // MARK: - Login Screen
        
        XCTAssertFalse(app.otherElements[AccessibilityIdentifiers.mainView.rawValue].exists,
                       "Should start on login screen, not main view")
        
        let carouselView = app.descendants(matching: .any)[AccessibilityIdentifiers.carouselView.rawValue]
        XCTAssertTrue(carouselView.waitForExistence(timeout: 10), "Carousel view should be visible on the login screen")
        
        let titleText = app.staticTexts[AccessibilityIdentifiers.titleFirstLine.rawValue]
        XCTAssertTrue(titleText.waitForExistence(timeout: 5), "Title text should be visible on login screen")
        
        let loginButton = app.buttons[AccessibilityIdentifiers.loginButton.rawValue]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Login button should exist")
        
        let emailTextField = app.textFields[AccessibilityIdentifiers.emailTextField.rawValue]
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 5), "Email text field should exist")
        emailTextField.tap()
        emailTextField.typeText("user@example.com")
        
        let passwordTextField = app.secureTextFields[AccessibilityIdentifiers.passwordTextField.rawValue]
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5), "Password text field should exist")
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        
        XCTAssert(loginButton.isEnabled, "Login button should be enabled after entering credentials")
        loginButton.tap()
        
        // MARK: - Library Screen (Main View)
        
        let mainView = app.otherElements[AccessibilityIdentifiers.mainView.rawValue]
        XCTAssertTrue(mainView.waitForExistence(timeout: 5), "Main view should appear after successful login")
        
        let libraryTitle = app.staticTexts[AccessibilityIdentifiers.libraryTitle.rawValue]
        XCTAssertTrue(libraryTitle.waitForExistence(timeout: 5), "Library title should be visible")
        
        // MARK: - Open a Book from Grid
        
        app.swipeUp()
        
        let bookCards = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", AccessibilityIdentifiers.bookCard.rawValue))
        let firstCard = bookCards.firstMatch
        XCTAssertTrue(firstCard.waitForExistence(timeout: 5), "Book card should be visible")
        firstCard.tap()
        
        // MARK: - Reading Screen
        
        let readingScreen = app.scrollViews[AccessibilityIdentifiers.readingScreen.rawValue]
        XCTAssertTrue(readingScreen.waitForExistence(timeout: 5), "Reading screen should appear after tapping book card")
        
        // MARK: - Open Chapter
        
        let readButton = app.buttons[AccessibilityIdentifiers.readButton.rawValue]
        XCTAssertTrue(readButton.waitForExistence(timeout: 5), "Read button should be visible")
        readButton.tap()
        
        // MARK: - Navigate Back from Chapter to Reading Screen
        
        let chapterBackButton = app.buttons[AccessibilityIdentifiers.chapterBackButton.rawValue]
        XCTAssertTrue(chapterBackButton.waitForExistence(timeout: 5), "Chapter back button should be visible")
        chapterBackButton.tap()
        
        XCTAssertTrue(readingScreen.waitForExistence(timeout: 5), "Reading screen should reappear after tapping back button from chapter")
        
        // MARK: - Navigate Back from Reading Screen to Library
        
        let backButton = app.buttons[AccessibilityIdentifiers.backButton.rawValue]
        if backButton.exists {
            backButton.tap()
        } else {
            app.swipeDown()
        }
        
        let libraryScreen = app.scrollViews[AccessibilityIdentifiers.libraryScreenView.rawValue]
        XCTAssertTrue(libraryScreen.waitForExistence(timeout: 5), "Library screen should appear after navigating back from reading screen")
        
        // MARK: - Navigate to Search via Tab Bar

        let searchTab = app.buttons["Search"]
        XCTAssertTrue(searchTab.waitForExistence(timeout: 5), "Search tab should exist")
        searchTab.tap()
        
        let searchTextField = app.textFields[AccessibilityIdentifiers.searchTextField.rawValue]
        XCTAssertTrue(searchTextField.waitForExistence(timeout: 5), "Search field should be visible")
        
        // MARK: -  Navigate to Bookmarks via Tab Bar
        
        let bookmarksTab = app.buttons["Bookmarks"]
        XCTAssertTrue(bookmarksTab.exists, "Bookmarks tab should exist")
        bookmarksTab.tap()
        
        let bookmarksTitle = app.staticTexts[AccessibilityIdentifiers.bookmarksTitle.rawValue]
        XCTAssertTrue(bookmarksTitle.waitForExistence(timeout: 5), "Bookmarks title should be visible")
        
        // MARK: -  Return to Library to Complete the Cycle
        
        let libraryTab = app.buttons["Library"]
        XCTAssertTrue(libraryTab.exists, "Library tab should exist")
        libraryTab.tap()
    
        XCTAssertTrue(libraryTitle.waitForExistence(timeout: 5), "Library title should be visible")
    }
}
