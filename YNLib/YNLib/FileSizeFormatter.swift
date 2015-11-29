//
//  FileSizeFormatter.swift
//  YNLib
//
//  Created by stoprain on 11/29/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import UIKit

public class FileSizeFormatter: NSNumberFormatter {
    
    public static let sharedFormatter = FileSizeFormatter()
    
    private let sUnits = ["B", "K", "M", "G", "T", "P", "E", "Z", "Y"]
    private var useBaseTenUnits = false
    
    public override func stringFromNumber(number: NSNumber) -> String? {
        
        let multiplier = self.useBaseTenUnits ? 1000 : 1024
        var bytes = number.integerValue
        var exponent = 0
        
        while bytes >= multiplier {
            bytes /= multiplier
            exponent++
            if exponent == sUnits.count-1 {
                break
            }
        }
        
        return "\(bytes)\(sUnits[exponent])"
        
    }

}
