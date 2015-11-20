//
//  Utils.swift
//  YNLib
//
//  Created by stoprain on 11/6/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import UIKit

class Utils {
    
    static var seqIndex = 0
    
    class func getSeqSeed() -> Int {
        seqIndex++
        if seqIndex >= Int.max {
            seqIndex = 1
        }
        return seqIndex
    }
    
    class func getSeq() -> String {
        return "\(self.getSeqSeed())"
    }

}
