//
//  YNLibTests.swift
//  YNLibTests
//
//  Created by stoprain on 10/8/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import XCTest
@testable import YNLib

class YNLibTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRandomInRange() {
        for _ in 0...100 {
            print(NumberUtils.randomInRange(1...6))
        }
        XCTAssert(true, "Pass")
    }
    
    func testRandomColorHex() {
        print(UIColor(hexString: ColorUtils.randomColorHex(.RGB)))
        print(UIColor(hexString: ColorUtils.randomColorHex(.ARGB)))
        print(UIColor(hexString: ColorUtils.randomColorHex(.RRGGBB)))
        print(UIColor(hexString: ColorUtils.randomColorHex(.AARRGGBB)))
        XCTAssert(true, "Pass")
    }
    
}
