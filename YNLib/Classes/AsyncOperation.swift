//
//  AsyncOperation.swift
//  YNLib
//
//  Created by stoprain on 10/29/15.
//  Copyright © 2015 stoprain. All rights reserved.
//

import Foundation

@objc
open class AsyncOperation: Operation {
    
    public enum State {
        case ready, executing, finished
        func keyPath() -> String {
            switch self {
            case .ready:
                return "isReady"
            case .executing:
                return "isExecuting"
            case .finished:
                return "isFinished"
            }
        }
    }
    
    open var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath())
            willChangeValue(forKey: state.keyPath())
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath())
            didChangeValue(forKey: state.keyPath())
        }
    }
    
    public enum Result {
        case unknown, succeed, failed, canceled
    }
    
    open var result = Result.unknown
    
    open override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    open override var isExecuting: Bool {
        return state == .executing
    }
    
    open override var isFinished: Bool {
        return state == .finished
    }
    
    open override var isAsynchronous: Bool {
        return true
    }
    
    open var seq: String = "asop \(AsyncOperation.getSeq())"
    
    open override func cancel() {
        self.result = Result.canceled
        if self.state == State.executing {
            self.state = State.finished
        }
        super.cancel()
    }
    
    open override func start() {
        if self.isCancelled {
            self.state = State.finished
        } else {
            self.state = State.executing
        }
        
        if self.state == State.executing {
            self.starting()
        }
    }
    
    open func starting() {
        assert(true, "AsyncOperation starting not implemented!")
    }
    
    fileprivate static var seqIndex = 0
    
    /**
     Seq for debugging
     
     - returns: seq number
     */
    
    open class func getSeqSeed() -> Int {
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
    
    open class func getSeq() -> String {
        return "\(self.getSeqSeed())"
    }

}
