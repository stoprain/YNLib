//
//  Chrono.swift
//  YNLib
//
//  Created by stoprain on 1/15/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import UIKit

public class Chrono {
    
    private(set) static var ticks = [Int: CFTimeInterval]()
    
    public static func start(hash: Int) {
        objc_sync_enter(ticks); defer { objc_sync_exit(ticks) }
        ticks[hash] = CACurrentMediaTime()
    }
    
    public static func stop(hash: Int, handler: (elapse: CFTimeInterval) -> Void) {
        objc_sync_enter(ticks); defer { objc_sync_exit(ticks) }
        var elapse: CFTimeInterval = 0
        if let t = ticks[hash] {
            elapse = CACurrentMediaTime() - t
            ticks.removeValueForKey(hash)
        }
        handler(elapse: elapse)
    }

}
