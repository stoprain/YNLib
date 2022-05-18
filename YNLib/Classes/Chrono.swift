//
//  Chrono.swift
//  YNLib
//
//  Created by stoprain on 1/15/16.
//  Copyright © 2016 stoprain. All rights reserved.
//

import Foundation
import QuartzCore

@objc
open class Chrono: NSObject {
    
    public private(set) static var ticks = [Int: CFTimeInterval]()
    
    open static func start(_ hash: Int) {
        objc_sync_enter(ticks); defer { objc_sync_exit(ticks) }
        ticks[hash] = CACurrentMediaTime()
    }
    
    open static func stop(_ hash: Int, handler: (_ elapse: CFTimeInterval) -> Void) {
        objc_sync_enter(ticks); defer { objc_sync_exit(ticks) }
        var elapse: CFTimeInterval = 0
        if let t = ticks[hash] {
            elapse = CACurrentMediaTime() - t
            ticks.removeValue(forKey: hash)
        }
        handler(elapse)
    }

}
