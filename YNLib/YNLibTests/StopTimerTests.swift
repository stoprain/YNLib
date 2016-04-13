//
//  StopTimerTests.swift
//  Groubum
//
//  Created by stoprain on 9/21/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import XCTest
@testable import YNLib

class StopTimerTests: XCTestCase {
    
    func test_Flow() {
        let expectation = self.expectationWithDescription("test stoptimer")
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
        
        self.waitForExpectationsWithTimeout(1) { (error: NSError?) -> Void in
            if error != nil {
                XCTFail("stoptimer is broken \(error)")
            }
        }
    }

}
