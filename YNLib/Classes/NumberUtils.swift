//
//  NumberUtils.swift
//  YNLib
//
//  Created by stoprain on 10/10/15.
//  Copyright © 2015 stoprain. All rights reserved.
//

import Foundation

@objc
open class NumberUtils: NSObject {
    
    /**
     Retrive a random number in given range
     
     - parameter range: the range
     
     - returns: the random number
     */

    open class func randomInRange(_ range: ClosedRange<Int>) -> Int {
        let count = UInt32(range.upperBound - range.lowerBound)
        return Int(arc4random_uniform(count)) + range.lowerBound
    }
    
}
