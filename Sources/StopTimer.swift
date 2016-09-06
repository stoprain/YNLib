//
//  StopTimer.swift
//  RunloopTest
//
//  Created by stoprain on 7/8/15.
//  Copyright (c) 2015 stoprain. All rights reserved.
//

import Foundation

/**
    StopTimer
*/

public class StopTimer {
    
    public class Task {
        var uuid: String = ""
        var from: NSTimeInterval = 0
        var interval: NSTimeInterval = 0
        var block: ()->() = {}
        var repeats: Bool = false
    }
    
    let MinInterval = 0.05
    
    var timer: NSTimer?
    var tasks = [Task]()
    var runLoopMode: String?
    
    private static let shareInstance = StopTimer()
    
    public class var shareTimer: StopTimer {
        return shareInstance
    }
    
    public init(runLoopMode: String? = nil) {
        self.runLoopMode = runLoopMode
    }
    
    /**
        Stop the StopTimer, all the existing block will be removed.
    */
    
    public func stop() {
        self.tasks = [Task]()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /**
        Pause the StopTimer.
    */
    
    public func pause() {
        let t = NSDate().timeIntervalSince1970
        for task in self.tasks {
            task.interval = NSTimeInterval(task.interval - (t - task.from))
        }
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /**
        Resume the StopTimer.
    */
    
    public func resume() {
        let t = NSDate().timeIntervalSince1970
        for task in self.tasks {
            task.from = t
        }
        self.start()
    }
    
    private func start() {
        if self.timer == nil {
            if let mode = self.runLoopMode {
                self.timer = NSTimer(timeInterval: MinInterval, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
                NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: mode)
            } else {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(MinInterval, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc private func onTimer() {
        let t = NSDate().timeIntervalSince1970
        let activeTasks = self.tasks.filter { t - $0.from > $0.interval }
        self.tasks = self.tasks.filter { t - $0.from <= $0.interval }
        for task in activeTasks {
            task.block()
            if task.repeats {
                task.from = NSDate().timeIntervalSince1970
                self.tasks.append(task)
            }
        }
        // Stop the timer if there is no tasks
        if self.tasks.count == 0 {
            self.stop()
        }
    }
    
    /**
     Add block to StopTimer.
     
     - parameter interval: Excute the block after interval
     - parameter repeats:  repeats the block
     - parameter block:    block The block to be excuted
     
     - returns: The uuid for access the block late
     */
    
    public func addBlock(interval: NSTimeInterval, repeats: Bool = false, block: ()->()) -> String {
        let node = Task()
        node.uuid = NSUUID().UUIDString
        node.from = NSDate().timeIntervalSince1970
        node.interval = interval
        node.block = block
        node.repeats = repeats
        self.tasks.append(node)
        self.start()
        return node.uuid
    }
    
    /**
     Remove block from StopTimer
     
     - parameter uuid: The uuid of the block
     */
    
    public func removeBlock(uuid: String) {
        self.tasks = self.tasks.filter { $0.uuid != uuid }
    }
   
}
