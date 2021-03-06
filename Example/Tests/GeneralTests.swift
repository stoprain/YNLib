//
//  GeneralTests.swift
//  YNLib_Tests
//
//  Created by stoprain on 30/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import YNLib

class GeneralTests: XCTestCase {
    
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
        print(UIColor(hexString: ColorUtils.randomColorHex(.rgb)))
        print(UIColor(hexString: ColorUtils.randomColorHex(.argb)))
        print(UIColor(hexString: ColorUtils.randomColorHex(.rrggbb)))
        print(UIColor(hexString: ColorUtils.randomColorHex(.aarrggbb)))
        XCTAssert(true, "Pass")
    }
    
    func testAppSandboxHelper() {
        print("AppSandboxHelper documentsPath >> \(AppSandboxHelper.documentsPath)")
        print("AppSandboxHelper cachesPath    >> \(AppSandboxHelper.cachesPath)")
        XCTAssert(true, "Pass")
    }
    
    func testFileSizeFormatter() {
        let f = FileSizeFormatter.sharedFormatter
        XCTAssert(f.string(from: 666) == "666B")
        XCTAssert(f.string(from: 6666) == "6K")
        XCTAssert(f.string(from: 66666) == "65K")
        XCTAssert(f.string(from: 666666) == "651K")
        XCTAssert(f.string(from: 6666666) == "6M")
    }
    
    func testMetaNumberFormatter() {
        let f = MetaNumberFormatter.sharedFormatter
        XCTAssert(f.string(from: 666) == "666")
        XCTAssert(f.string(from: 6666) == "6666")
        XCTAssert(f.string(from: 66666) == "6.66万")
        XCTAssert(f.string(from: 666666) == "66.66万")
        XCTAssert(f.string(from: 6666666) == "666.66万")
        XCTAssert(f.string(from: 66666666) == "6666.66万")
        XCTAssert(f.string(from: 666666666) == "66666.66万")
        XCTAssert(f.string(from: 6666666666) == "666666.66万")
        XCTAssert(f.string(from: 66666666666) == "6666666.66万")
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
    
    func testStringTerminator() {
        XCTAssert(StringTerminator.subStringToAmount("0123456789", amount: 5) == "01234")
        XCTAssert(StringTerminator.subStringToAmountWithDot("0123456789", amount: 5) == "01234...")
        XCTAssert(StringTerminator.countString("00x00叉00") == 9)
        XCTAssert(StringTerminator.countString("溜溜溜") == 6)
        XCTAssert(StringTerminator.countString("666") == 3)
        XCTAssert(StringTerminator.countString("liuliuliu") == 9)
    }
    
    func testDataUtils() {
        let d = "whatsup".data(using: String.Encoding.utf8)!
        XCTAssert(d.md5HexString() == "57ba23b78c1fd7c8ac4bf325f6f40d9a")
    }
    
    func testUserDataHelper() {
        XCTAssert(UserDataHelper.userDataPath == "")
        XCTAssert(UserDataHelper.downloadPath == "")
        XCTAssert(UserDataHelper.uploadPath == "")
        UserDataHelper.check("pegasus")
        XCTAssert(UserDataHelper.userDataPath.range(of: "/Library/Caches/pegasus") != nil)
        XCTAssert(UserDataHelper.downloadPath.range(of: "/Library/Caches/pegasus/download") != nil)
        XCTAssert(UserDataHelper.uploadPath.range(of: "/Library/Caches/pegasus/upload") != nil)
    }
    
    func testShareDataManager() {
        SharedDataManager.setObject("ha" as AnyObject, prefix: "setting", key: "hei")
        XCTAssert(SharedDataManager.objectForPrefix("setting", key: "hei") as! String == "ha")
    }
    
}
