//
//  ReadingScreenUITests.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import XCTest

class ReadingScreenUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launchArguments = [
            "-ui-testing-logged-in",
            "-UITestMode"
        ]
        app.terminate()
        app.launch()
        let timeout: TimeInterval = 5
        let libraryScreen = app.scrollViews[AccessibilityIdentifiers.libraryScreenView.rawValue]
        XCTAssertTrue(libraryScreen.waitForExistence(timeout: timeout), "Library screen should appear when logged in")
        app.swipeUp()
        let bookCards = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", AccessibilityIdentifiers.bookCard.rawValue))
        let firstCard = bookCards.firstMatch
        XCTAssertTrue(firstCard.waitForExistence(timeout: timeout), "Book card should be visible")
        firstCard.tap()

        let readingScreen = app.scrollViews[AccessibilityIdentifiers.readingScreen.rawValue]
        XCTAssertTrue(readingScreen.waitForExistence(timeout: timeout), "Reading screen should appear after tapping book card")
    }

    func testReadingScreenElementsPresence() throws {
        XCTAssertTrue(app.buttons[AccessibilityIdentifiers.backButton.rawValue].exists, "Back button should be visible")
        XCTAssertTrue(app.images[AccessibilityIdentifiers.bookPoster.rawValue].exists, "Book poster should be visible")
        XCTAssertTrue(app.buttons[AccessibilityIdentifiers.readButton.rawValue].exists, "Read button should be visible")
        XCTAssertTrue(app.buttons[AccessibilityIdentifiers.favoriteButton.rawValue].exists, "Favorite button should be visible")
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.bookTitle.rawValue].exists, "Book title should be visible")
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.authorName.rawValue].exists, "Author name should be visible")
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.bookDescription.rawValue].exists, "Book description should be visible")
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.contentsTitle.rawValue].exists, "Contents title should be visible")
        let chapterItems = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", AccessibilityIdentifiers.chapterListItem.rawValue))
        XCTAssertGreaterThan(chapterItems.count, 0, "At least one chapter should be visible")
    }

    func testFavoriteButtonToggle() throws {
        let favoriteButton = app.buttons[AccessibilityIdentifiers.favoriteButton.rawValue]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5), "Favorite button should be visible")
        let initialButtonLabel = favoriteButton.label
        favoriteButton.tap()
        let expectation = XCTestExpectation(description: "Wait for favorite button state to change")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        let updatedButtonLabel = favoriteButton.label
        XCTAssertNotEqual(initialButtonLabel, updatedButtonLabel, "Favorite button label should change after tapping")
    }

    func testOpeningChapter() throws {
        let readButton = app.buttons[AccessibilityIdentifiers.readButton.rawValue]
        XCTAssertTrue(readButton.waitForExistence(timeout: 5), "Read button should be visible")
        readButton.tap()
        let expectation = XCTestExpectation(description: "Wait for chapter reading view to appear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        app.swipeDown()
    }

    func testTappingSpecificChapter() throws {
        let chapterItems = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", AccessibilityIdentifiers.chapterListItem.rawValue))
        let firstChapter = chapterItems.firstMatch
        XCTAssertTrue(firstChapter.waitForExistence(timeout: 5), "First chapter should be visible")
        app.swipeUp()
        firstChapter.tap()
        let expectation = XCTestExpectation(description: "Wait for chapter reading view to appear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        app.swipeDown()
    }

    func testNavigationBackToLibrary() throws {
        let backButton = app.buttons[AccessibilityIdentifiers.backButton.rawValue]
        XCTAssertTrue(backButton.waitForExistence(timeout: 5), "Back button should be visible")
        backButton.tap()
        let libraryScreen = app.scrollViews[AccessibilityIdentifiers.libraryScreenView.rawValue]
        XCTAssertTrue(libraryScreen.waitForExistence(timeout: 5), "Library screen should appear after tapping back button")
    }
}
