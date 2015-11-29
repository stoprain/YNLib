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
            let n = NumberUtils.randomInRange(1...6)
            if n < 1 || n > 6 {
                XCTFail("Random number out of range")
            }
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
    
    func testAppSandboxHelper() {
        print("AppSandboxHelper documentsPath >> \(AppSandboxHelper.documentsPath)")
        print("AppSandboxHelper cachesPath    >> \(AppSandboxHelper.cachesPath)")
        XCTAssert(true, "Pass")
    }
    
    func testFileSizeFormatter() {
        print(FileSizeFormatter.sharedFormatter.stringFromNumber(666))
        print(FileSizeFormatter.sharedFormatter.stringFromNumber(6666))
        print(FileSizeFormatter.sharedFormatter.stringFromNumber(66666))
        print(FileSizeFormatter.sharedFormatter.stringFromNumber(666666))
        print(FileSizeFormatter.sharedFormatter.stringFromNumber(6666666))
    }
    
}
