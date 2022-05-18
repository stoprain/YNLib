//
//  StringUtils.swift
//  YNLib
//
//  Created by stoprain on 7/19/16.
//  Copyright © 2016 stoprain. All rights reserved.
//

import UIKit

@objc
open class StringUtils: NSObject {
    
    public static func boundingRect(_ s: String, size: CGSize, font: UIFont) -> CGRect {
        return (s as NSString).boundingRect(with: size,
                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                    attributes: [NSAttributedString.Key.font: font],
                                                    context: nil)
    }
    
}

public extension String {
    func boundingRect(_ size: CGSize, font: UIFont) -> CGRect {
        return StringUtils.boundingRect(self, size: size, font: font)
    }
    
    func boundingRect(_ size: CGSize, systemFontSize: CGFloat) -> CGRect {
        return self.boundingRect(size, font: UIFont.systemFont(ofSize: systemFontSize))
    }
    
    func boundingRect(_ size: CGSize, boldSystemFontOfSize: CGFloat) -> CGRect {
        return self.boundingRect(size, font: UIFont.boldSystemFont(ofSize: boldSystemFontOfSize))
    }
}
