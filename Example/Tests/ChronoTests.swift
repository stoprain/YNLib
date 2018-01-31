//
//  ChronoTests.swift
//  YNLib_Tests
//
//  Created by stoprain on 30/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import YNLib

class ChronoTests: XCTestCase {
    
    func test_Concurrency() {
        
        let expectation = self.expectation(description: "test chrono")
        
        for i in 0...10 {
            DispatchQueue.global().async {
                Chrono.start(i)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            for i in 0...10 {
                DispatchQueue.global().async {
                    Chrono.stop(i, handler: { (elapse) -> Void in
                    })
                }
            }
        }
        
        let _ = StopTimer.shareTimer.addBlock(3) { () -> () in
            XCTAssert(Chrono.ticks.count == 0, "Pass")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (error) in
            XCTAssert(Chrono.ticks.count == 0, "Pass")
        }

    }
    
}
