//
//  iRingTunes_ProUITests.swift
//  iRingTunes ProUITests
//
//  Created by Dani Tox on 17/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import XCTest

class iRingTunes_ProUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        snapshot("0Launch")
        
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        
        app.buttons.firstMatch.tap()
        
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Brani"]/*[[".cells.staticTexts[\"Brani\"]",".staticTexts[\"Brani\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.otherElements["Artista sconosciuto — Album sconosciuto"]/*[[".cells.otherElements[\"Artista sconosciuto — Album sconosciuto\"]",".otherElements[\"Artista sconosciuto — Album sconosciuto\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Esporta"].tap()
        app.navigationBars["Suoneria"].buttons["Fine"].tap()
        app.buttons["Le tue suonerie"].tap()
        app.navigationBars["Manager"].buttons["Fine"].tap()
    
    }
    
}
