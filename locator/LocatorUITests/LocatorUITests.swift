//
//  LocatorUITests.swift
//  LocatorUITests
//
//  Created by Michael Knoch on 13/04/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import XCTest

class LocatorUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
    }
    
}
