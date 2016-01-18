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
        objc_sync_enter(ticks); defer { objc_sync_exit(ticks) }
        ticks[hash] = NSDate().timeIntervalSince1970
    }
    
    public static func stop(hash: Int, handler: (elapse: NSTimeInterval) -> Void) {
        objc_sync_enter(ticks); defer { objc_sync_exit(ticks) }
        var elapse: NSTimeInterval = 0
        if let t = ticks[hash] {
            elapse = NSDate().timeIntervalSince1970 - t
            ticks.removeValueForKey(hash)
        }
        handler(elapse: elapse)
    }

}
