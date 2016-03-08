//
//  MetaNumberFormatter.swift
//  Groubum
//
//  Created by 李锦心 on 15/6/11.
//  Copyright (c) 2015年 yunio. All rights reserved.
//

import Foundation

public class MetaNumberFormatter: NSNumberFormatter {
    
    public static let sharedFormatter = MetaNumberFormatter()
    
    public override func stringFromNumber(number: NSNumber) -> String? {
        var valueText = "\(number)"
        if number.longLongValue >= 10000 {
            let stringValue = String(format: "%.1f",(Double(number)/10000.0))
            let range = Range(start: stringValue.endIndex.advancedBy(-1), end: stringValue.endIndex)
            if stringValue.substringWithRange(range) == "0" {
                valueText = String(number.longLongValue/10000) + "万"
            } else {
                valueText = stringValue + "万"
            }
        }
        
        return valueText
    }

}