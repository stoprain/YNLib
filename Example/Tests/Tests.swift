import UIKit
import XCTest
import YNLib

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPinyinSearchHelper() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
        
        var rs = PinyinSearchHelper.search(source: "ab345👩‍👩‍👧‍👧你好👩‍👩‍👧‍👧12cd5你好", criteria: "你好")
        XCTAssert(rs[0].location == 16 && rs[0].length == 2, "")
        XCTAssert(rs[1].location == 34 && rs[1].length == 2, "")
        
        rs = PinyinSearchHelper.search(source: "👩‍👩‍👧‍👧12345你好", criteria: "👩‍👩‍👧‍👧")
        XCTAssert(rs[0].location == 0 && rs[0].length == 11, "")
        
        rs = PinyinSearchHelper.search(source: "12345你好a", criteria: "好a")
        XCTAssert(rs[0].location == 6 && rs[0].length == 2, "")
        
        rs = PinyinSearchHelper.search(source: "abcd 你好a", criteria: "d 你")
        XCTAssert(rs[0].location == 3 && rs[0].length == 3, "")
        
        rs = PinyinSearchHelper.search(source: "Sim", criteria: "Sim")
        XCTAssert(rs[0].location == 0 && rs[0].length == 3, "")

        rs = PinyinSearchHelper.search(source: "上海上海", criteria: "sh")
        XCTAssert(rs[0].location == 0 && rs[0].length == 2, "")
        XCTAssert(rs[1].location == 2 && rs[1].length == 2, "")
        
        rs = PinyinSearchHelper.search(source: "上海sh上海", criteria: "sh")
        XCTAssert(rs[0].location == 2 && rs[0].length == 2, "")

    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
