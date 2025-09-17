//
//  AppStoreSnapshots.swift
//  AppStoreSnapshots
//
//  Created by Vignesh Sankaran on 13/2/2025.
//

import XCTest

final class AppStoreSnapshots: XCTestCase {
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        app = nil
        continueAfterFailure = false
        super.tearDown()
    }

    func test_full_screen() {
        snapshot("Launch")
    }

    func test_tap_mortgage_field() {
        let firstTextField = app.textFields.firstMatch
        firstTextField.tap()
        snapshot("Tap mortgage field")
    }

    func test_tap_chart() {
        app.swipeUp()

        app.segmentedControls["chart-picker"].buttons["picker-total"].tap()
        app.otherElements["interest-bar-mark"].tap()
        snapshot("Tap interest bar")
    }
}
