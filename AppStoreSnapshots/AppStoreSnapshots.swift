//
//  AppStoreSnapshots.swift
//  AppStoreSnapshots
//
//  Created by Vignesh Sankaran on 13/2/2025.
//

import XCTest

final class AppStoreSnapshots: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func test_full_screen() {}

    func test_tap_mortgage_field() {
        let firstTextField = app.textFields.firstMatch
        firstTextField.tap()
    }

    func test_tap_chart() {
        app.swipeUp()
        app.otherElements["interest-bar-mark"].tap()
    }
}
