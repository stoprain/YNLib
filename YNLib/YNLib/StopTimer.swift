//
//  StopTimer.swift
//  RunloopTest
//
//  Created by stoprain on 7/8/15.
//  Copyright (c) 2015 stoprain. All rights reserved.
//

import UIKit

/**
    StopTimer
*/

class StopTimer: NSObject {
    
    class Task {
        var uuid: String = ""
        var from: NSTimeInterval = 0
        var interval: NSTimeInterval = 0
        var block: ()->() = {}
    }
    
    let MinInterval = 0.05
    
    var timer: NSTimer?
    var tasks = [Task]()
    
    private static let shareInstance = StopTimer()
    
    class var shareTimer: StopTimer {
        return shareInstance
    }
    
    /**
        Stop the StopTimer, all the existing block will be removed.
    */
    
    func stop() {
        self.tasks = [Task]()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /**
        Pause the StopTimer.
    */
    
    func pause() {
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
    
    func resume() {
        let t = NSDate().timeIntervalSince1970
        for task in self.tasks {
            task.from = t
        }
        self.start()
    }
    
    private func start() {
        if self.timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(MinInterval, target: self, selector: Selector("onTimer"), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func onTimer() {
        let t = NSDate().timeIntervalSince1970
        let activeTasks = self.tasks.filter { t - $0.from > $0.interval }
        self.tasks = self.tasks.filter { t - $0.from <= $0.interval }
        for task in activeTasks {
            task.block()
        }
        // Stop the timer if there is no tasks
        if self.tasks.count == 0 {
            self.stop()
        }
    }

    /**
        Add block to StopTimer.

        :param: interval Excute the block after interval.
        :param: block The block to be excuted.

        :returns: The uuid for access the block later.
    */
    
    func addBlock(interval: NSTimeInterval, block: ()->()) -> String {
        let node = Task()
        node.uuid = NSUUID().UUIDString
        node.from = NSDate().timeIntervalSince1970
        node.interval = interval
        node.block = block
        self.tasks.append(node)
        self.start()
        return node.uuid
    }
    
    /**
        Remove block from StopTimer
    
        :param: The uuid of the block.
    */
    
    func removeBlock(uuid: String) {
        self.tasks = self.tasks.filter { $0.uuid != uuid }
    }
   
}
