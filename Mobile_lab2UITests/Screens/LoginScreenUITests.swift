//
//  LoginScreenUITests.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import XCTest

class LoginScreenUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
       
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing-logged-out", "-UITests"]
        
        app.terminate()
        
        app.launch()
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
    }
    
    func testCompleteLoginFlowAndCarouselElements() throws {
        XCTAssertFalse(app.otherElements[AccessibilityIdentifiers.mainView.rawValue].exists,
                       "Should start on login screen, not main view")
        
        print("UI HIERARCHY: \(app.debugDescription)")
        
        let carouselView = app.descendants(matching: .any)[AccessibilityIdentifiers.carouselView.rawValue]
        XCTAssertTrue(carouselView.waitForExistence(timeout: 10), "Carousel view should be visible on the login screen.")
        
        let titleText = app.staticTexts[AccessibilityIdentifiers.titleFirstLine.rawValue]
        XCTAssertTrue(titleText.waitForExistence(timeout: 5), "Title text should be visible on login screen")
           
        let bookLabels = ["Book_1", "Book_2", "Book_3"]
        for bookLabel in bookLabels {
            let image = app.images.matching(NSPredicate(format: "label == %@", bookLabel)).firstMatch
            XCTAssertTrue(image.waitForExistence(timeout: 5), "Image with label '\(bookLabel)' should be visible.")
        }
        let loginButton = app.buttons[AccessibilityIdentifiers.loginButton.rawValue]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Login button should exist.")
        
        XCTAssert(!loginButton.isEnabled, "Login button should be disabled.")
        
        let emailTextField = app.textFields[AccessibilityIdentifiers.emailTextField.rawValue]
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 5), "Email text field should exist.")
        emailTextField.tap()
        emailTextField.typeText("user@example.com")
        
        let passwordTextField = app.secureTextFields[AccessibilityIdentifiers.passwordTextField.rawValue]
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5), "Password text field should exist.")
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        
        XCTAssert(loginButton.isEnabled, "Login button should be now enabled.")
        
        loginButton.tap()
        
        let mainView = app.otherElements[AccessibilityIdentifiers.mainView.rawValue]
        XCTAssertTrue(mainView.waitForExistence(timeout: 5), "Main view should appear after successful login.")
    }
}
