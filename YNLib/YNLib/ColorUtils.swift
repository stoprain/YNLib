//
//  ColorUtils.swift
//  YNLib
//
//  Created by stoprain on 10/10/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import UIKit

public enum ColorFormat: Int {
    case RGB = 3, ARGB = 4, RRGGBB = 6, AARRGGBB = 8
}

public class ColorUtils {
    
    public class func randomColorHex(format: ColorFormat) -> String {
        var hex = "#"
        for _ in 0 ..< format.rawValue {
            hex += String(NumberUtils.randomInRange(0...15), radix: 16)
        }
        return hex
    }
    
}

public extension UIColor {
    convenience init(hexString: String) {
        
        func stof(hex: String, start: Int, end: Int) -> CGFloat {
            let s = hex[hex.startIndex.advancedBy(start)..<hex.startIndex.advancedBy(end)]
            return CGFloat(strtoul(s, nil, 16))
        }
        
        let s = hexString.stringByReplacingOccurrencesOfString("#", withString: "")
        var alpha: CGFloat = 0
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        switch s.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
        case 3:
            alpha = 255
            red = stof(s, start: 0, end: 1)
            green = stof(s, start: 1, end: 2)
            blue = stof(s, start: 2, end: 3)
        case 4:
            alpha = stof(s, start: 0, end: 1)
            red = stof(s, start: 1, end: 2)
            green = stof(s, start: 2, end: 3)
            blue = stof(s, start: 3, end: 4)
        case 6:
            alpha = 255
            red = stof(s, start: 0, end: 2)
            green = stof(s, start: 2, end: 4)
            blue = stof(s, start: 4, end: 6)
        case 8:
            alpha = stof(s, start: 0, end: 2)
            red = stof(s, start: 2, end: 4)
            green = stof(s, start: 4, end: 6)
            blue = stof(s, start: 6, end: 8)
        default:
            break
        }
        
        alpha /= 255.0
        red /= 255.0
        green /= 255.0
        blue /= 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
        
//        print(hexString)
//        print(alpha, red, green, blue)
    }
}
