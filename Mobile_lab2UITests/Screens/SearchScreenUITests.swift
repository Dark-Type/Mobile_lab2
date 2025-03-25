//
//  SearchScreenUITests.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import XCTest

class SearchScreenUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments = [
            "-ui-testing-logged-in",
            "-UITestMode"
        ]
        
        app.launch()
        
        let searchTab = app.buttons["Search"]
        XCTAssertTrue(searchTab.waitForExistence(timeout: 5), "Search tab should exist")
        searchTab.tap()
        
        let searchTextField = app.textFields[AccessibilityIdentifiers.searchTextField.rawValue]
        XCTAssertTrue(searchTextField.waitForExistence(timeout: 5), "Search text field should be visible")
    }
    
    func testSearchScreenInitialElements() throws {
        XCTAssertTrue(app.textFields[AccessibilityIdentifiers.searchTextField.rawValue].exists,
                      "Search text field should be visible")
        
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.recentSearchesTitle.rawValue].exists,
                      "Recent searches title should be visible")
        
        let recentSearchItems = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH %@",
                                                                     AccessibilityIdentifiers.recentSearchItem.rawValue))
        XCTAssertGreaterThan(recentSearchItems.count, 0, "At least one recent search item should be visible")
        
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.genresSectionTitle.rawValue].exists,
                      "Genres section title should be visible")
        
        let genreCards = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH %@",
                                                              AccessibilityIdentifiers.genreCard.rawValue))
        XCTAssertGreaterThan(genreCards.count, 0, "At least one genre card should be visible")

        app.swipeUp()
        
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.authorsSectionTitle.rawValue].exists,
                      "Authors section title should be visible")
        
        let authorCards = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH %@",
                                                               AccessibilityIdentifiers.authorCard.rawValue))
        XCTAssertGreaterThan(authorCards.count, 0, "At least one author card should be visible")
    }
    
    func testSearchFunctionality() throws {
        let searchTextField = app.textFields[AccessibilityIdentifiers.searchTextField.rawValue]
        XCTAssertTrue(searchTextField.exists, "Search text field should exist")
        
        searchTextField.tap()
        searchTextField.typeText("code")
        
        XCTAssertFalse(app.staticTexts[AccessibilityIdentifiers.recentSearchesTitle.rawValue].isHittable,
                       "Recent searches section should not be visible during search")
        XCTAssertFalse(app.staticTexts[AccessibilityIdentifiers.genresSectionTitle.rawValue].isHittable,
                       "Genres section should not be visible during search")
        
        let searchResultItems = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@",
                                                                 AccessibilityIdentifiers.searchResultItem.rawValue))
        XCTAssertGreaterThan(searchResultItems.count, 0, "At least one search result should be visible")
        
        let clearButton = app.buttons[AccessibilityIdentifiers.searchClearButton.rawValue]
        XCTAssertTrue(clearButton.exists, "Clear button should be visible when search text is entered")
        clearButton.tap()
        
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.recentSearchesTitle.rawValue].waitForExistence(timeout: 5),
                      "Recent searches title should reappear after clearing search")
    }
    
    func testRecentSearchItemTap() throws {
        let recentSearchItems = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH %@",
                                                                     AccessibilityIdentifiers.recentSearchItem.rawValue))
        XCTAssertGreaterThan(recentSearchItems.count, 0, "At least one recent search item should be visible")
        
        let firstRecentSearch = recentSearchItems.firstMatch
        let recentSearchText = firstRecentSearch.label
        firstRecentSearch.tap()
        
        let searchTextField = app.textFields[AccessibilityIdentifiers.searchTextField.rawValue]
        let searchValue = searchTextField.value as? String ?? ""
        XCTAssertEqual(searchValue, recentSearchText, "Search text field should contain the tapped recent search")
        
        let searchResults = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@",
                                                             AccessibilityIdentifiers.searchResultItem.rawValue)).firstMatch
        XCTAssertTrue(searchResults.waitForExistence(timeout: 5), "Search results should appear after tapping a recent search")
    }
    
    func testGenreTap() throws {
        let genreCards = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH %@",
                                                              AccessibilityIdentifiers.genreCard.rawValue))
        XCTAssertGreaterThan(genreCards.count, 0, "At least one genre card should be visible")
        
        let firstGenre = genreCards.firstMatch
        let genreText = firstGenre.label
        firstGenre.tap()
        
        let searchTextField = app.textFields[AccessibilityIdentifiers.searchTextField.rawValue]
        let searchValue = searchTextField.value as? String ?? ""
        XCTAssertTrue(searchValue.contains("жанр:"), "Search text should contain genre prefix")
        XCTAssertTrue(searchValue.contains(genreText), "Search text should contain the tapped genre name")
        
        print(app.debugDescription)
        let searchResults = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@",
                                                             AccessibilityIdentifiers.searchResultItem.rawValue)).firstMatch
        XCTAssertTrue(searchResults.waitForExistence(timeout: 5), "Search results should appear after tapping a genre")
    }
    
    func testAuthorTap() throws {
        app.swipeUp()
        
        let authorCards = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH %@",
                                                               AccessibilityIdentifiers.authorCard.rawValue))
        XCTAssertGreaterThan(authorCards.count, 0, "At least one author card should be visible")
        
        let firstAuthor = authorCards.firstMatch
        firstAuthor.tap()
        
        let searchTextField = app.textFields[AccessibilityIdentifiers.searchTextField.rawValue]
        let searchValue = searchTextField.value as? String ?? ""
        XCTAssertTrue(searchValue.contains("автор:"), "Search text should contain author prefix")
        
        let searchResults = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@",
                                                             AccessibilityIdentifiers.searchResultItem.rawValue)).firstMatch
        XCTAssertTrue(searchResults.waitForExistence(timeout: 5), "Search results should appear after tapping an author")
    }
    
    func testBookSelectionFromSearchResults() throws {
        let searchTextField = app.textFields[AccessibilityIdentifiers.searchTextField.rawValue]
        searchTextField.tap()
        searchTextField.typeText("a")
        
        let searchResultItems = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@",
                                                                 AccessibilityIdentifiers.searchResultItem.rawValue))
        XCTAssertGreaterThan(searchResultItems.count, 0, "At least one search result should be visible")
        
        let firstSearchResult = searchResultItems.firstMatch
        firstSearchResult.tap()
        
        let backButton = app.buttons[AccessibilityIdentifiers.backButton.rawValue]
        if backButton.exists {
            backButton.tap()
        } else {
            app.swipeDown()
        }
    }
    
    func testEmptyStates() throws {
        let emptyStateApp = XCUIApplication()
        emptyStateApp.launchArguments = [
            "-ui-testing-logged-in",
            "-UITestMode",
            "-empty-state-test"
        ]
        emptyStateApp.launch()
        
        let searchTab = emptyStateApp.buttons["Search"]
        XCTAssertTrue(searchTab.waitForExistence(timeout: 5), "Search tab should exist")
        searchTab.tap()
        
        print(app.debugDescription)
        let searchTextField = emptyStateApp.textFields.firstMatch
        XCTAssertTrue(searchTextField.waitForExistence(timeout: 5), "Search text field should be visible")
        
        let emptyGenres = emptyStateApp.staticTexts[AccessibilityIdentifiers.emptyGenresView.rawValue]
        XCTAssertTrue(emptyGenres.waitForExistence(timeout: 5), "Empty genres view should be visible")
        
        emptyStateApp.swipeUp()
        
        let emptyAuthors = emptyStateApp.staticTexts[AccessibilityIdentifiers.emptyAuthorsView.rawValue]
        XCTAssertTrue(emptyAuthors.waitForExistence(timeout: 5), "Empty authors view should be visible")
        
        searchTextField.tap()
        searchTextField.typeText("blob")

        let emptySearchResults = emptyStateApp.staticTexts[AccessibilityIdentifiers.emptySearchResultsView.rawValue]
        XCTAssertTrue(emptySearchResults.waitForExistence(timeout: 5), "Empty search results view should be visible")
        
        let noResultsText = emptyStateApp.staticTexts["Ничего не найдено"]
        XCTAssertTrue(noResultsText.exists, "Should display 'Ничего не найдено' message")
        
        let tryDifferentText = emptyStateApp.staticTexts["Попробуйте другие запросы"]
        XCTAssertTrue(tryDifferentText.exists, "Should display 'Попробуйте другие запросы' message")
        
        let clearButton = emptyStateApp.buttons[AccessibilityIdentifiers.searchClearButton.rawValue]
        XCTAssertTrue(clearButton.exists, "Clear button should be visible")
        clearButton.tap()
    }
}
