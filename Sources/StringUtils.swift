//
//  StringUtils.swift
//  YNLib
//
//  Created by stoprain on 7/19/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import UIKit

@objc
public class StringUtils: NSObject {
    
    public static func boundingRect(s: String, size: CGSize, font: UIFont) -> CGRect {
        return (s as NSString).boundingRectWithSize(size,
                                                    options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                    attributes: [NSFontAttributeName: font],
                                                    context: nil)
    }
    
}

public extension String {
    public func boundingRect(size: CGSize, font: UIFont) -> CGRect {
        return StringUtils.boundingRect(self, size: size, font: font)
    }
    
    public func boundingRect(size: CGSize, systemFontSize: CGFloat) -> CGRect {
        return self.boundingRect(size, font: UIFont.systemFontOfSize(systemFontSize))
    }
    
    public func boundingRect(size: CGSize, boldSystemFontOfSize: CGFloat) -> CGRect {
        return self.boundingRect(size, font: UIFont.boldSystemFontOfSize(boldSystemFontOfSize))
    }
}
