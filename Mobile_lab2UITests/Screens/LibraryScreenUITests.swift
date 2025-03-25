//
//  LibraryScreenUITests.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import XCTest

class LibraryScreenUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        app.launchArguments = [
            "-ui-testing-logged-in",
            "-UITestMode"
        ]
        app.terminate()
        app.launch()
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
    }

    func testLibraryScreenElementsPresence() throws {
        let libraryScreen = app.scrollViews[AccessibilityIdentifiers.libraryScreenView.rawValue]
        XCTAssertTrue(libraryScreen.waitForExistence(timeout: 5), "Library screen should appear when logged in")
        let libraryTitle = app.staticTexts[AccessibilityIdentifiers.libraryTitle.rawValue]
        XCTAssertTrue(libraryTitle.exists, "Library title should be visible")
        let newBooksTitle = app.staticTexts[AccessibilityIdentifiers.newBooksTitle.rawValue]
        XCTAssertTrue(newBooksTitle.exists, "New books title should be visible")
        let popularBooksTitle = app.staticTexts[AccessibilityIdentifiers.popularBooksTitle.rawValue]
        XCTAssertTrue(popularBooksTitle.exists, "Popular books title should be visible")
        let carousel = app.scrollViews[AccessibilityIdentifiers.booksCarousel.rawValue]
        XCTAssertTrue(carousel.waitForExistence(timeout: 5), "Books carousel should be visible")
        let booksGrid = app.otherElements[AccessibilityIdentifiers.booksGrid.rawValue]
        XCTAssertTrue(booksGrid.waitForExistence(timeout: 5), "Books grid should be visible")
        let carouselItems = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", AccessibilityIdentifiers.carouselItem.rawValue))
        XCTAssertGreaterThan(carouselItems.count, 0, "At least one carousel item should be visible")
        let bookCards = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", AccessibilityIdentifiers.bookCard.rawValue))
        XCTAssertGreaterThan(bookCards.count, 0, "At least one book card should be visible")
    }

    func testCarouselItemTapOpensReadingScreen() throws {
        let carouselItems = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", AccessibilityIdentifiers.carouselItem.rawValue))
        let firstItem = carouselItems.firstMatch
        XCTAssertTrue(firstItem.waitForExistence(timeout: 5), "Carousel item should be visible")
        firstItem.tap()
        let readingScreen = app.scrollViews[AccessibilityIdentifiers.readingScreen.rawValue]
        XCTAssertTrue(readingScreen.waitForExistence(timeout: 5), "Reading screen should appear after tapping carousel item")
        let backButton = app.buttons[AccessibilityIdentifiers.backButton.rawValue]
        if backButton.exists {
            backButton.tap()
        } else {
            app.swipeDown()
        }
    }

    func testGridItemTapOpensReadingScreen() throws {
        app.swipeUp()
        let bookCards = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", AccessibilityIdentifiers.bookCard.rawValue))
        let firstCard = bookCards.firstMatch
        XCTAssertTrue(firstCard.waitForExistence(timeout: 5), "Book card should be visible")
        firstCard.tap()
        let readingScreen = app.scrollViews[AccessibilityIdentifiers.readingScreen.rawValue]
        XCTAssertTrue(readingScreen.waitForExistence(timeout: 5), "Reading screen should appear after tapping book card")
        let backButton = app.buttons[AccessibilityIdentifiers.backButton.rawValue]
        if backButton.exists {
            backButton.tap()
        } else {
            app.swipeDown()
        }
    }

    func testEmptyStateLibrary() throws {
        app.terminate()
        let emptyStateApp = XCUIApplication()
        emptyStateApp.launchArguments = [
            "-ui-testing-logged-in",
            "-UITestMode",
            "-empty-state-test"
        ]
        emptyStateApp.launch()
        let libraryTitle = emptyStateApp.staticTexts[AccessibilityIdentifiers.libraryTitle.rawValue]
        XCTAssertTrue(libraryTitle.exists, "Library title should be visible even in empty state")
        let newBooksTitle = emptyStateApp.staticTexts[AccessibilityIdentifiers.newBooksTitle.rawValue]
        XCTAssertTrue(newBooksTitle.exists, "New books title should be visible even in empty state")
        let popularBooksTitle = emptyStateApp.staticTexts[AccessibilityIdentifiers.popularBooksTitle.rawValue]
        XCTAssertTrue(popularBooksTitle.exists, "Popular books title should be visible even in empty state")
        let emptyCarouselMessage = emptyStateApp.staticTexts[AccessibilityIdentifiers.emptyCarouselMessage.rawValue]
        XCTAssertTrue(emptyCarouselMessage.waitForExistence(timeout: 5), "Empty carousel message should be visible")
        let emptyGridMessage = emptyStateApp.staticTexts[AccessibilityIdentifiers.emptyGridMessage.rawValue]
        XCTAssertTrue(emptyGridMessage.waitForExistence(timeout: 5), "Empty grid message should be visible")
        let carouselItems = emptyStateApp.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", AccessibilityIdentifiers.carouselItem.rawValue))
        XCTAssertEqual(carouselItems.count, 0, "No carousel items should be visible in empty state")
        let bookCards = emptyStateApp.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", AccessibilityIdentifiers.bookCard.rawValue))
        XCTAssertEqual(bookCards.count, 0, "No book cards should be visible in empty state")
    }
}
