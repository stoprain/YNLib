//
//  MetaNumberFormatter.swift
//  Groubum
//
//  Created by 李锦心 on 15/6/11.
//  Copyright (c) 2015年 yunio. All rights reserved.
//

import Foundation

open class MetaNumberFormatter: NumberFormatter {
    
    open static let sharedFormatter = MetaNumberFormatter()
    
    open override func string(from number: NSNumber) -> String {
        var valueText = "\(number)"
        let length = valueText.lengthOfBytes(using: String.Encoding.utf8)
        if length > 4 {
            valueText = valueText.insert(".", ind: length-4)
            valueText = valueText[..<valueText.index(valueText.endIndex, offsetBy: -2)] + "万"
        }
        
        return valueText
    }

}

extension String {
    func insert(_ string:String, ind:Int) -> String {
        return String(self.prefix(ind)) + string + String(self.suffix(self.count-ind))
    }
}
