//
//  AsyncOperation.swift
//  YNLib
//
//  Created by stoprain on 10/29/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import UIKit

public class AsyncOperation: NSOperation {
    
    public enum State {
        case Ready, Executing, Finished
        func keyPath() -> String {
            switch self {
            case Ready:
                return "isReady"
            case Executing:
                return "isExecuting"
            case Finished:
                return "isFinished"
            }
        }
    }
    
    public var state = State.Ready {
        willSet {
            willChangeValueForKey(newValue.keyPath())
            willChangeValueForKey(state.keyPath())
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath())
            didChangeValueForKey(state.keyPath())
        }
    }
    
    public enum Result {
        case Unknown, Succeed, Failed, Canceled
    }
    
    public var result = Result.Unknown
    
    public override var ready: Bool {
        return super.ready && state == .Ready
    }
    
    public override var executing: Bool {
        return state == .Executing
    }
    
    public override var finished: Bool {
        return state == .Finished
    }
    
    public override var asynchronous: Bool {
        return true
    }
    
    public var seq: String = "asop \(AsyncOperation.getSeq())"
    
    public override func cancel() {
        self.result = Result.Canceled
        if self.state == State.Executing {
            self.state = State.Finished
        }
        super.cancel()
    }
    
    public override func start() {
        if self.cancelled {
            self.state = State.Finished
        } else {
            self.state = State.Executing
        }
        
        if self.state == State.Executing {
            self.starting()
        }
    }
    
    public func starting() {
        assert(true, "AsyncOperation starting not implemented!")
    }
    
    private static var seqIndex = 0
    
    /**
     Seq for debugging
     
     - returns: seq number
     */
    
    public class func getSeqSeed() -> Int {
        seqIndex += 1
        if seqIndex >= Int.max {
            seqIndex = 1
        }
        return seqIndex
    }
    
    /**
     Seq for debugging
     
     - returns: seq string
     */
    
    public class func getSeq() -> String {
        return "\(self.getSeqSeed())"
    }

}
