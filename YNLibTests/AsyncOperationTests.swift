//
//  AsyncOperationTests.swift
//  YNLib
//
//  Created by stoprain on 10/30/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import XCTest
@testable import YNLib

class AutoCompleteOperation: AsyncOperation {
    
    var completeAfter = 0.1
    
    override func starting() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            StopTimer.shareTimer.addBlock(self.completeAfter, block: { () -> () in
                self.state = State.Finished
            })
        }
    }
}

class AsyncOperationTests: XCTestCase {
    
    let queue = NSOperationQueue()
    
    func test_Flow() {
        let expectation = self.expectationWithDescription("test async operation")
        queue.maxConcurrentOperationCount = 10
        for i in 0..<100 {
            let op = AutoCompleteOperation()
            op.completeAfter = Double(i) * 0.1
            queue.addOperation(op)
        }
        StopTimer.shareTimer.addBlock(1, block: { () -> () in
            if self.queue.operationCount <= 90 {
                expectation.fulfill()
            }
        })

        self.waitForExpectationsWithTimeout(10) { [weak self] (error: NSError?) -> Void in
            if let wself = self {
                print(wself.queue)
            }
            if error != nil {
                XCTFail("async operation is broken \(error)")
            }
        }

    }
    
}
