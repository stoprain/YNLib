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

open class StopTimer {
    
    open class Task {
        var uuid: String = ""
        var from: TimeInterval = 0
        var interval: TimeInterval = 0
        var block: ()->() = {}
        var repeats: Bool = false
    }
    
    let MinInterval = 0.05
    
    var timer: Timer?
    var tasks = [Task]()
    var runLoopMode: String?
    
    fileprivate static let shareInstance = StopTimer()
    
    open class var shareTimer: StopTimer {
        return shareInstance
    }
    
    public init(runLoopMode: String? = nil) {
        self.runLoopMode = runLoopMode
    }
    
    /**
        Stop the StopTimer, all the existing block will be removed.
    */
    
    open func stop() {
        self.tasks = [Task]()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /**
        Pause the StopTimer.
    */
    
    open func pause() {
        let t = Date().timeIntervalSince1970
        for task in self.tasks {
            task.interval = TimeInterval(task.interval - (t - task.from))
        }
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /**
        Resume the StopTimer.
    */
    
    open func resume() {
        let t = Date().timeIntervalSince1970
        for task in self.tasks {
            task.from = t
        }
        self.start()
    }
    
    fileprivate func start() {
        if self.timer == nil {
            if let mode = self.runLoopMode {
                self.timer = Timer(timeInterval: MinInterval, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
                RunLoop.current.add(self.timer!, forMode: RunLoopMode(rawValue: mode))
            } else {
                self.timer = Timer.scheduledTimer(timeInterval: MinInterval, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc fileprivate func onTimer() {
        let t = Date().timeIntervalSince1970
        let activeTasks = self.tasks.filter { t - $0.from > $0.interval }
        self.tasks = self.tasks.filter { t - $0.from <= $0.interval }
        for task in activeTasks {
            task.block()
            if task.repeats {
                task.from = Date().timeIntervalSince1970
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
    
    open func addBlock(_ interval: TimeInterval, repeats: Bool = false, block: @escaping ()->()) -> String {
        let node = Task()
        node.uuid = UUID().uuidString
        node.from = Date().timeIntervalSince1970
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
    
    open func removeBlock(_ uuid: String) {
        self.tasks = self.tasks.filter { $0.uuid != uuid }
    }
   
}
