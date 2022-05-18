//
//  FileSizeFormatter.swift
//  YNLib
//
//  Created by stoprain on 11/29/15.
//  Copyright © 2015 stoprain. All rights reserved.
//

import Foundation

open class FileSizeFormatter: NumberFormatter {
    
    open static let sharedFormatter = FileSizeFormatter()
    
    fileprivate let sUnits = ["B", "K", "M", "G", "T", "P", "E", "Z", "Y"]
    fileprivate var useBaseTenUnits = false
    
    open override func string(from number: NSNumber) -> String? {
        
        let multiplier = self.useBaseTenUnits ? 1000 : 1024
        var bytes = number.intValue
        var exponent = 0
        
        while bytes >= multiplier {
            bytes /= multiplier
            exponent += 1
            if exponent == sUnits.count-1 {
                break
            }
        }
        
        return "\(bytes)\(sUnits[exponent])"
        
    }

}
