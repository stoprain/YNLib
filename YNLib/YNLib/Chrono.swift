//
//  Chrono.swift
//  YNLib
//
//  Created by stoprain on 1/15/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import UIKit

public class Chrono {
    
    private(set) static var ticks = [Int: NSTimeInterval]()
    
    public static func start(hash: Int) {
        objc_sync_enter(ticks)
        ticks[hash] = NSDate().timeIntervalSince1970
        objc_sync_exit(ticks)
    }
    
    public static func stop(hash: Int, handler: (elapse: NSTimeInterval) -> Void) {
        var elapse: NSTimeInterval = 0
        objc_sync_enter(ticks)
        if let t = ticks[hash] {
            elapse = NSDate().timeIntervalSince1970 - t
            ticks.removeValueForKey(hash)
        }
        objc_sync_exit(ticks)
        handler(elapse: elapse)
    }

}
