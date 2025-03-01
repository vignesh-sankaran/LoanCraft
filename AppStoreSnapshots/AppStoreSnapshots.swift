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
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.lifetime = .keepAlways

    }

    func test_tap_mortgage_field() {
        let firstTextField = app.textFields.firstMatch
        firstTextField.tap()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Enter your mortgage amount"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func test_tap_chart() {
        app.swipeUp()
        app.otherElements["interest-bar-mark"].tap()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Tap the graph to see principal and interest"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
