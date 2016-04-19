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
    
    public override func stringFromNumber(number: NSNumber) -> String {
        var valueText = "\(number)"
        let length = valueText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if length > 4 {
            valueText = valueText.insert(".", ind: length-4)
            valueText = valueText.substringToIndex(valueText.endIndex.advancedBy(-2)) + "万"
        }
        
        return valueText
    }

}

extension String {
    func insert(string:String, ind:Int) -> String {
        return String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
}