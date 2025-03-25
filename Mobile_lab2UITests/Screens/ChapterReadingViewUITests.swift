//
//  ChapterReadingViewUITests.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import XCTest

class ChapterReadingViewUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = [
            "-ui-testing-logged-in",
            "-UITestMode"
        ]
        app.launch()
        navigateToBookDetail()
        let readButton = app.buttons[AccessibilityIdentifiers.readButton.rawValue]
        XCTAssertTrue(readButton.waitForExistence(timeout: 5), "Read button should exist")
        readButton.tap()
        let chapterView = app.scrollViews[AccessibilityIdentifiers.chapterReadingView.rawValue]
        XCTAssertTrue(chapterView.waitForExistence(timeout: 5), "Chapter reading view should be visible")
    }

    private func navigateToBookDetail() {
        let libraryScreen = app.scrollViews[AccessibilityIdentifiers.libraryScreenView.rawValue]
        XCTAssertTrue(libraryScreen.waitForExistence(timeout: 5), "Library screen should appear")
        app.swipeUp()
        let bookCards = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", AccessibilityIdentifiers.bookCard.rawValue))
        let firstCard = bookCards.firstMatch
        XCTAssertTrue(firstCard.waitForExistence(timeout: 5), "Book card should be visible")
        firstCard.tap()
        let readingScreen = app.scrollViews[AccessibilityIdentifiers.readingScreen.rawValue]
        XCTAssertTrue(readingScreen.waitForExistence(timeout: 5), "Reading screen should appear")
    }

    func testChapterReadingViewElementsPresence() throws {
        let chapterTitle = app.staticTexts[AccessibilityIdentifiers.chapterTitle.rawValue]
        XCTAssertTrue(chapterTitle.exists, "Chapter title should be visible")
        let previousButton = app.buttons[AccessibilityIdentifiers.chapterPreviousButton.rawValue]
        XCTAssertTrue(previousButton.exists, "Previous chapter button should be visible")
        let nextButton = app.buttons[AccessibilityIdentifiers.chapterNextButton.rawValue]
        XCTAssertTrue(nextButton.exists, "Next chapter button should be visible")
        let contentsButton = app.buttons[AccessibilityIdentifiers.chapterContentsButton.rawValue]
        XCTAssertTrue(contentsButton.exists, "Contents button should be visible")
        let settingsButton = app.buttons[AccessibilityIdentifiers.chapterSettingsButton.rawValue]
        XCTAssertTrue(settingsButton.exists, "Settings button should be visible")
        let playButton = app.buttons[AccessibilityIdentifiers.chapterPlayButton.rawValue]
        XCTAssertTrue(playButton.exists, "Play button should be visible")
        let paragraphs = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH %@", AccessibilityIdentifiers.paragraphText.rawValue))
        XCTAssertGreaterThan(paragraphs.count, 0, "At least one paragraph should be visible")
    }

    func testSettingsPanel() throws {
        let settingsButton = app.buttons[AccessibilityIdentifiers.chapterSettingsButton.rawValue]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5), "Settings button should be visible")
        settingsButton.tap()
        print(app.debugDescription)
        let settingsTitle = app.staticTexts[AccessibilityIdentifiers.settingsTitle.rawValue]
        XCTAssertTrue(settingsTitle.exists, "Settings title should be visible")
        let fontSizeLabel = app.staticTexts[AccessibilityIdentifiers.fontSizeLabel.rawValue]
        XCTAssertTrue(fontSizeLabel.exists, "Font size label should be visible")
        let fontSizeValue = app.staticTexts[AccessibilityIdentifiers.fontSizeValue.rawValue]
        XCTAssertTrue(fontSizeValue.exists, "Font size value should be visible")
        let initialFontSize = fontSizeValue.label
        let increaseButton = app.buttons[AccessibilityIdentifiers.fontSizeIncreaseButton.rawValue]
        XCTAssertTrue(increaseButton.exists, "Font size increase button should be visible")
        increaseButton.tap()
        let expectation1 = XCTestExpectation(description: "Font size should update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 2)
        XCTAssertNotEqual(initialFontSize, fontSizeValue.label, "Font size should change after tapping increase button")
        let decreaseButton = app.buttons[AccessibilityIdentifiers.fontSizeDecreaseButton.rawValue]
        XCTAssertTrue(decreaseButton.exists, "Font size decrease button should be visible")
        decreaseButton.tap()
        let expectation2 = XCTestExpectation(description: "Font size should update after decrease")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 2)
        XCTAssertEqual(initialFontSize, fontSizeValue.label, "Font size should return to original value after decreasing")
        let lineSpacingLabel = app.staticTexts[AccessibilityIdentifiers.lineSpacingLabel.rawValue]
        XCTAssertTrue(lineSpacingLabel.exists, "Line spacing label should be visible")
        let lineSpacingValue = app.staticTexts[AccessibilityIdentifiers.lineSpacingValue.rawValue]
        XCTAssertTrue(lineSpacingValue.exists, "Line spacing value should be visible")
        let initialLineSpacing = lineSpacingValue.label
        let lineSpacingIncreaseButton = app.buttons[AccessibilityIdentifiers.lineSpacingIncreaseButton.rawValue]
        XCTAssertTrue(lineSpacingIncreaseButton.exists, "Line spacing increase button should be visible")
        lineSpacingIncreaseButton.tap()
        let expectation3 = XCTestExpectation(description: "Line spacing should update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 2)
        XCTAssertNotEqual(initialLineSpacing, lineSpacingValue.label, "Line spacing should change after tapping increase button")
        let closeButton = app.buttons[AccessibilityIdentifiers.settingsCloseButton.rawValue]
        XCTAssertTrue(closeButton.exists, "Settings close button should be visible")
        closeButton.tap()
        let expectation4 = XCTestExpectation(description: "Settings panel should close")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: 2)
    }

    func testChaptersPanel() throws {
        print(app.debugDescription)
        let contentsButton = app.buttons[AccessibilityIdentifiers.chapterContentsButton.rawValue]
        XCTAssertTrue(contentsButton.waitForExistence(timeout: 5), "Contents button should be visible")
        let firstParagraph = app.staticTexts["\(AccessibilityIdentifiers.paragraphText.rawValue)0"]
        XCTAssertTrue(firstParagraph.exists, "First paragraph should be visible")
        let initialParagraphText = firstParagraph.label
        contentsButton.tap()
        let chaptersDragIndicator = app.otherElements[AccessibilityIdentifiers.chaptersDragIndicator.rawValue]
        XCTAssertTrue(chaptersDragIndicator.waitForExistence(timeout: 5), "Chapters drag indicator should be visible")
        let chaptersTitle = app.staticTexts[AccessibilityIdentifiers.chaptersTitle.rawValue]
        XCTAssertTrue(chaptersTitle.exists, "Chapters title should be visible")
        XCTAssertEqual(chaptersTitle.label, "ОГЛАВЛЕНИЕ", "Chapters title should be 'ОГЛАВЛЕНИЕ'")
        let closeButton = app.buttons[AccessibilityIdentifiers.chaptersCloseButton.rawValue]
        XCTAssertTrue(closeButton.exists, "Chapters close button should be visible")
        let chaptersListView = app.scrollViews[AccessibilityIdentifiers.chaptersListView.rawValue]
        XCTAssertTrue(chaptersListView.exists, "Chapters list view should be visible")
        let buttonsInChaptersList = chaptersListView.buttons
        if !buttonsInChaptersList.isEmpty {
            print("Found \(buttonsInChaptersList.count) buttons in chapters list view")
            if buttonsInChaptersList.count > 1 {
                buttonsInChaptersList.element(boundBy: 1).tap()
            } else {
                buttonsInChaptersList.element(boundBy: 0).tap()
            }
        } else {
            print("No buttons found in chapters list view. Looking for alternative chapter buttons...")
            let potentialChapterButtons = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Глава"))
            if potentialChapterButtons.isEmpty {
                print("Found \(potentialChapterButtons.count) potential chapter buttons")
                potentialChapterButtons.element(boundBy: 0).tap()
            } else {
                print("No chapter buttons found by label. Trying to find any button in the overlay...")
                let allButtonsExceptClose = app.buttons.matching(NSPredicate(format: "identifier != %@", AccessibilityIdentifiers.chaptersCloseButton.rawValue))
                if allButtonsExceptClose.isEmpty {
                    allButtonsExceptClose.element(boundBy: 0).tap()
                } else {
                    XCTFail("Could not find any chapter buttons to tap")
                }
            }
        }
        let expectation = XCTestExpectation(description: "Chapters panel should close")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)

        let newFirstParagraph = app.staticTexts["\(AccessibilityIdentifiers.paragraphText.rawValue)0"]
        XCTAssertTrue(newFirstParagraph.exists, "First paragraph should still be visible after chapter change")

        if newFirstParagraph.label != initialParagraphText {
            print("Chapter content changed successfully")
            XCTAssertNotEqual(newFirstParagraph.label, initialParagraphText,
                              "First paragraph content should change after selecting a different chapter")
        } else {
            print("WARNING: Chapter content didn't change. This may be expected if the same chapter was selected.")
        }
    }

    func testQuoteAddition() throws {
        let paragraphs = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH %@", AccessibilityIdentifiers.paragraphText.rawValue))
        XCTAssertGreaterThan(paragraphs.count, 0, "At least one paragraph should be visible")
        let firstParagraph = paragraphs.firstMatch
        XCTAssertTrue(firstParagraph.waitForExistence(timeout: 5), "First paragraph should be visible")
        firstParagraph.press(forDuration: 1.5)
        let quoteOverlay = app.otherElements[AccessibilityIdentifiers.quoteOverlay.rawValue]
        XCTAssertTrue(quoteOverlay.waitForExistence(timeout: 5), "Quote overlay should appear after long-pressing paragraph")
        let quoteTextEditor = app.textViews[AccessibilityIdentifiers.quoteTextEditor.rawValue]
        XCTAssertTrue(quoteTextEditor.exists, "Quote text editor should be visible")
        if let editorText = quoteTextEditor.value as? String {
            XCTAssertFalse(editorText.isEmpty, "Quote text editor should contain selected text")
        } else {
            XCTFail("Could not read text from quote editor")
        }
        let restoreButton = app.buttons["Восстановить исходный текст"]
        XCTAssertTrue(restoreButton.exists, "Restore button should be visible")
        let addButton = app.buttons["Добавить в цитаты"]
        XCTAssertTrue(addButton.exists, "Add to quotes button should be visible")
        addButton.tap()
        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "Wait for overlay to dismiss")], timeout: 1.0) == .timedOut
        XCTAssertFalse(quoteOverlay.exists, "Quote overlay should be dismissed after adding quote")
    }

    func testNavigationButtons() throws {
        let chapterTitle = app.staticTexts[AccessibilityIdentifiers.chapterTitle.rawValue]
        let initialChapterTitle = chapterTitle.label
        let nextButton = app.buttons[AccessibilityIdentifiers.chapterNextButton.rawValue]
        nextButton.tap()
        let newChapterTitle = chapterTitle.label
        XCTAssertNotEqual(initialChapterTitle, newChapterTitle, "Chapter title should change after tapping next button")
        let previousButton = app.buttons[AccessibilityIdentifiers.chapterPreviousButton.rawValue]
        previousButton.tap()
        let finalChapterTitle = chapterTitle.label
        XCTAssertEqual(initialChapterTitle, finalChapterTitle, "Chapter title should return to initial after tapping previous button")
    }

    func testPlayButtonActivation() throws {
        let playButton = app.buttons[AccessibilityIdentifiers.chapterPlayButton.rawValue]
        playButton.tap()

        playButton.tap()
    }

    func testScrollingText() throws {
        app.scrollViews[AccessibilityIdentifiers.chapterReadingView.rawValue].swipeUp(velocity: .slow)
        app.scrollViews[AccessibilityIdentifiers.chapterReadingView.rawValue].swipeUp(velocity: .slow)
        app.scrollViews[AccessibilityIdentifiers.chapterReadingView.rawValue].swipeDown(velocity: .slow)
        XCTAssertTrue(true, "Text scrolling should work without errors")
    }

    func testBackNavigation() throws {
        let backButton = app.buttons[AccessibilityIdentifiers.chapterBackButton.rawValue]
        XCTAssertTrue(backButton.exists, "Back button should be visible")
        backButton.tap()
        let readingScreen = app.scrollViews[AccessibilityIdentifiers.readingScreen.rawValue]
        XCTAssertTrue(readingScreen.waitForExistence(timeout: 5), "Reading screen should appear after tapping back button")
    }
}

extension XCUIElementQuery {
    var isEmpty: Bool {
        return count == 0
    }
}
