//
//  BookmarksScreenUITests.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import XCTest

class BookmarksScreenUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments = [
            "-ui-testing-logged-in",
            "-UITestMode"
        ]
        
        app.launch()
        
        let bookmarksTab = app.buttons["Bookmarks"]
        XCTAssertTrue(bookmarksTab.waitForExistence(timeout: 5), "Bookmarks tab should exist")
        bookmarksTab.tap()
    }
    
    func testBookmarksScreenElements() throws {
        let bookmarksTitle = app.staticTexts[AccessibilityIdentifiers.bookmarksTitle.rawValue]
        XCTAssertTrue(bookmarksTitle.exists, "Bookmarks title should be visible")
        
        let currentReadingTitle = app.staticTexts[AccessibilityIdentifiers.currentReadingSectionTitle.rawValue]
        XCTAssertTrue(currentReadingTitle.exists, "Current reading section title should be visible")
        
        let favoritesTitle = app.staticTexts[AccessibilityIdentifiers.favoriteBooksSectionTitle.rawValue]
        XCTAssertTrue(favoritesTitle.exists, "Favorites section title should be visible")
        
        app.swipeUp()
        
        let quotesTitle = app.staticTexts[AccessibilityIdentifiers.quotesSectionTitle.rawValue]
        XCTAssertTrue(quotesTitle.exists, "Quotes section title should be visible")
    }
    
    func testCurrentBookInteraction() throws {
        let currentBook = app.buttons[AccessibilityIdentifiers.currentReadingBookItem.rawValue]
        print(app.debugDescription)
        if currentBook.exists {
            let continueButton = app.buttons[AccessibilityIdentifiers.continueReadingButton.rawValue]
            XCTAssertTrue(continueButton.exists, "Continue reading button should be visible")
            
            continueButton.tap()
            
            let backButton = app.buttons[AccessibilityIdentifiers.backButton.rawValue]
            if backButton.exists {
                backButton.tap()
            } else {
                app.swipeDown()
            }
            
            currentBook.tap()
            
            if backButton.exists {
                backButton.tap()
            } else {
                app.swipeDown()
            }
        } else {
            let emptyView = app.otherElements[AccessibilityIdentifiers.emptyCurrentReadingView.rawValue]
            XCTAssertTrue(emptyView.exists, "Empty current reading view should be visible when no book is being read")
        }
    }
    
    func testFavoriteBooksInteraction() throws {
        let favoritesBooksItems = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@",
                                                                   AccessibilityIdentifiers.favoriteBookItem.rawValue))
        
        if favoritesBooksItems.count > 0 {
            let firstFavoriteBook = favoritesBooksItems.element(boundBy: 0)
            firstFavoriteBook.tap()
            
            let backButton = app.buttons[AccessibilityIdentifiers.backButton.rawValue]
            if backButton.exists {
                backButton.tap()
            } else {
                app.swipeDown()
            }
        } else {
            let emptyView = app.otherElements[AccessibilityIdentifiers.emptyFavoriteBooksView.rawValue]
            XCTAssertTrue(emptyView.exists, "Empty favorites view should be visible when no favorites exist")
        }
    }
    
    func testQuotesDisplay() throws {
        app.swipeUp()
        
        let quotesTitle = app.staticTexts[AccessibilityIdentifiers.quotesSectionTitle.rawValue]
        XCTAssertTrue(quotesTitle.exists, "Quotes section title should be visible")
        print(app.debugDescription)
        let quoteItems = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH %@",
                                                              AccessibilityIdentifiers.quoteItem.rawValue))
        
        if quoteItems.count > 0 {
            XCTAssertTrue(quoteItems.element(boundBy: 0).exists, "At least one quote should be visible")
        } else {
            let emptyView = app.otherElements[AccessibilityIdentifiers.emptyQuotesView.rawValue]
            XCTAssertTrue(emptyView.exists, "Empty quotes view should be visible when no quotes exist")
        }
    }
    
    func testEmptyStates() throws {
        app.terminate()
        
        let emptyStateApp = XCUIApplication()
        emptyStateApp.launchArguments = [
            "-ui-testing-logged-in",
            "-UITestMode",
            "-empty-state-test"
        ]
        emptyStateApp.launch()
    
        let bookmarksTab = app.buttons["Bookmarks"]
        XCTAssertTrue(bookmarksTab.waitForExistence(timeout: 5), "Bookmarks tab should exist")
        bookmarksTab.tap()
        
        let bookmarksTitle = app.staticTexts[AccessibilityIdentifiers.bookmarksTitle.rawValue]
        XCTAssertTrue(bookmarksTitle.exists, "Bookmarks title should be visible")
              
        let favoritesTitle = app.staticTexts[AccessibilityIdentifiers.favoriteBooksSectionTitle.rawValue]
        XCTAssertTrue(favoritesTitle.exists, "Favorites section title should be visible")
              
        let emptyFavorites = app.staticTexts[AccessibilityIdentifiers.emptyFavoriteBooksView.rawValue]
        XCTAssertTrue(emptyFavorites.exists, "Empty favorites view should be visible")
              
        app.swipeUp()
              
        let quotesTitle = app.staticTexts[AccessibilityIdentifiers.quotesSectionTitle.rawValue]
        XCTAssertTrue(quotesTitle.exists, "Quotes section title should be visible")
              
        let emptyQuotes = app.staticTexts[AccessibilityIdentifiers.emptyQuotesView.rawValue]
        XCTAssertTrue(emptyQuotes.exists, "Empty quotes view should be visible")
              
        let noFavoritesText = app.staticTexts["У вас нет избранных книг"]
        XCTAssertTrue(noFavoritesText.exists, "Empty favorites message should be visible")
              
        let noQuotesText = app.staticTexts["У вас нет сохраненных цитат"]
        XCTAssertTrue(noQuotesText.exists, "Empty quotes message should be visible")
    }
}
