//
//  StringUtils.swift
//  YNLib
//
//  Created by stoprain on 7/19/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import UIKit

public extension String {
    public func boundingRectWithSize(size: CGSize, font: UIFont) -> CGRect {
        return (self as NSString).boundingRectWithSize(size,
                                                       options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                       attributes: [NSFontAttributeName: font],
                                                       context: nil)
    }
    
    public func boundingRectWithSize(size: CGSize, systemFontSize: CGFloat) -> CGRect {
        return self.boundingRectWithSize(size, font: UIFont.systemFontOfSize(systemFontSize))
    }
    
    public func boundingRectWithSize(size: CGSize, boldSystemFontOfSize: CGFloat) -> CGRect {
        return self.boundingRectWithSize(size, font: UIFont.boldSystemFontOfSize(boldSystemFontOfSize))
    }
}
