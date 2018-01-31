//
//  StopTimerTests.swift
//  YNLib_Tests
//
//  Created by stoprain on 30/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import YNLib

class StopTimerTests: XCTestCase {
    
    func test_Flow() {
        let expectation = self.expectation(description: "test stoptimer")
        var i = 0
        let _ = StopTimer.shareTimer.addBlock(0.1) { () -> () in
            i += 1
            let _ = StopTimer.shareTimer.addBlock(0.1, block: { () -> () in
                i += 2
            })
        }
        let b = StopTimer.shareTimer.addBlock(0.1, block: { () -> () in
            i = 1
        })
        let _ = StopTimer.shareTimer.addBlock(0.4, block: { () -> () in
            if i == 3 {
                expectation.fulfill()
            }
        })
        StopTimer.shareTimer.pause()
        StopTimer.shareTimer.resume()
        StopTimer.shareTimer.removeBlock(b)
        
        self.waitForExpectations(timeout: 1) { (error) in
            if error != nil {
                XCTFail("stoptimer is broken \(error.debugDescription)")
            }
        }
    }
    
}
