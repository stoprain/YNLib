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
        let f = FileSizeFormatter.sharedFormatter.stringFromNumber
        XCTAssert(f(666) == "666B")
        XCTAssert(f(6666) == "6K")
        XCTAssert(f(66666) == "65K")
        XCTAssert(f(666666) == "651K")
        XCTAssert(f(6666666) == "6M")
    }
    
    func testMetaNumberFormatter() {
        let f = MetaNumberFormatter.sharedFormatter.stringFromNumber
        XCTAssert(f(666) == "666")
        XCTAssert(f(6666) == "6666")
        XCTAssert(f(66666) == "6.66万")
        XCTAssert(f(666666) == "66.66万")
        XCTAssert(f(6666666) == "666.66万")
        XCTAssert(f(66666666) == "6666.66万")
        XCTAssert(f(666666666) == "66666.66万")
        XCTAssert(f(6666666666) == "666666.66万")
        XCTAssert(f(66666666666) == "6666666.66万")
    }
    
    func testColorUtils() {
        var a: CGFloat = 0
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        UIColor(hexString: "#01020304").getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssert(a == 1/255)
        XCTAssert(r == 2/255)
        XCTAssert(g == 3/255)
        XCTAssert(b == 4/255)
        UIColor(hexString: "#020304").getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssert(r == 2/255)
        XCTAssert(g == 3/255)
        XCTAssert(b == 4/255)
        UIColor(hexString: "#1234").getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssert(a == 1/255)
        XCTAssert(r == 2/255)
        XCTAssert(g == 3/255)
        XCTAssert(b == 4/255)
        UIColor(hexString: "#234").getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssert(r == 22/255)
        XCTAssert(g == 33/255)
        XCTAssert(b == 44/255)
    }
    
}
