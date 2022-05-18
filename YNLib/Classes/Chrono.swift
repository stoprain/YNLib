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
public class Chrono: NSObject {
    
    public private(set) static var ticks = [Int: CFTimeInterval]()
    private static var lock = NSLock()
    
    public static func start(_ hash: Int) {
        lock.lock()
        ticks[hash] = CACurrentMediaTime()
        lock.unlock()
    }
    
    public static func stop(_ hash: Int, handler: (_ elapse: CFTimeInterval) -> Void) {
        lock.lock()
        var elapse: CFTimeInterval = 0
        if let t = ticks[hash] {
            elapse = CACurrentMediaTime() - t
            ticks.removeValue(forKey: hash)
        }
        lock.unlock()
        handler(elapse)
    }

}
