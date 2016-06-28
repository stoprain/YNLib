//
//  NumberUtils.swift
//  YNLib
//
//  Created by stoprain on 10/10/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import Foundation

@objc
public class NumberUtils: NSObject {
    
    /**
     Retrive a random number in given range
     
     - parameter range: the range
     
     - returns: the random number
     */

    public class func randomInRange(range: Range<Int>) -> Int {
        let count = UInt32(range.endIndex - range.startIndex)
        return Int(arc4random_uniform(count)) + range.startIndex
    }
    
}
