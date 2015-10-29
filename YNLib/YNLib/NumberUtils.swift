//
//  NumberUtils.swift
//  YNLib
//
//  Created by stoprain on 10/10/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import UIKit

public class NumberUtils {

    public class func randomInRange(range: Range<Int>) -> Int {
        let count = UInt32(range.endIndex - range.startIndex)
        return Int(arc4random_uniform(count)) + range.startIndex
    }
    
}
