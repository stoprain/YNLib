//
//  AsyncOperationTests.swift
//  YNLib_Tests
//
//  Created by stoprain on 30/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import YNLib

class AutoCompleteOperation: AsyncOperation {
    
    var completeAfter = 0.1
    
    override func starting() {
        DispatchQueue.main.async {
            StopTimer.shareTimer.addBlock(self.completeAfter, block: { () -> () in
                self.state = State.finished
            })
        }
    }
}

class AsyncOperationTests: XCTestCase {
    
    let queue = OperationQueue()
    
    func test_Flow() {
        let expectation = self.expectation(description: "test async operation")
        queue.maxConcurrentOperationCount = 10
        for i in 0..<100 {
            let op = AutoCompleteOperation()
            op.completeAfter = Double(i) * 0.1
            queue.addOperation(op)
        }
        let _ = StopTimer.shareTimer.addBlock(1, block: { () -> () in
            if self.queue.operationCount <= 90 {
                expectation.fulfill()
            }
        })
        
        self.waitForExpectations(timeout: 10) { (error) in
            if error != nil {
                XCTFail("async operation is broken \(error.debugDescription)")
            }
        }
        
    }
    
}
