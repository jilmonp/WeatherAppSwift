//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by ADMIN on 23/06/22.
//

import XCTest

class WeatherAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    // UI test of Home Page
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        let searchTextField = app.textFields["Search"]
        searchTextField.tap()
        searchTextField.typeText("Amsterdam")
        let searchStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["SEARCH"]/*[[".buttons[\"SEARCH\"].staticTexts[\"SEARCH\"]",".staticTexts[\"SEARCH\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        searchStaticText.tap()
        let result = app.tables.staticTexts["Fri"]
        XCTAssertTrue(waitForElementToAppear(result))
    }
    func waitForElementToAppear(_ element: XCUIElement) -> Bool {
            let predicate = NSPredicate(format: "exists == true")
            let expectation = expectation(for: predicate, evaluatedWith: element,
                                          handler: nil)
            let result = XCTWaiter().wait(for: [expectation], timeout: 5)
            return result == .completed
    }
}
