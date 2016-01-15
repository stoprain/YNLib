//
//  Utils.swift
//  YNLib
//
//  Created by stoprain on 11/6/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import UIKit

class Utils {
    
    private static var seqIndex = 0
    
    /**
     Seq for debugging
     
     - returns: seq number
     */
    
    class func getSeqSeed() -> Int {
        seqIndex++
        if seqIndex >= Int.max {
            seqIndex = 1
        }
        return seqIndex
    }
    
    /**
     Seq for debugging
     
     - returns: seq string
     */
    
    class func getSeq() -> String {
        return "\(self.getSeqSeed())"
    }

}
