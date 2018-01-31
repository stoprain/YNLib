//
//  StringUtils.swift
//  YNLib
//
//  Created by stoprain on 7/19/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import UIKit

@objc
open class StringUtils: NSObject {
    
    open static func boundingRect(_ s: String, size: CGSize, font: UIFont) -> CGRect {
        return (s as NSString).boundingRect(with: size,
                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                    attributes: [NSAttributedStringKey.font: font],
                                                    context: nil)
    }
    
}

public extension String {
    public func boundingRect(_ size: CGSize, font: UIFont) -> CGRect {
        return StringUtils.boundingRect(self, size: size, font: font)
    }
    
    public func boundingRect(_ size: CGSize, systemFontSize: CGFloat) -> CGRect {
        return self.boundingRect(size, font: UIFont.systemFont(ofSize: systemFontSize))
    }
    
    public func boundingRect(_ size: CGSize, boldSystemFontOfSize: CGFloat) -> CGRect {
        return self.boundingRect(size, font: UIFont.boldSystemFont(ofSize: boldSystemFontOfSize))
    }
}
