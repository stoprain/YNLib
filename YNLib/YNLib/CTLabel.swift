//
//  CTLabel.swift
//  CoreTextTest
//
//  Created by stoprain on 4/14/16.
//  Copyright © 2016 stoprain. All rights reserved.
//

import UIKit

public class CTLabel: UIImageView {
    
    public func updateText(string: NSAttributedString, block: ((size: CGSize) -> ())? = nil) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let r = string.boundingRectWithSize(
                CGSizeZero,
                options: .UsesLineFragmentOrigin,
                context: nil)
            let rect = CGRectMake(0, 0, ceil(r.size.width), ceil(r.size.height))
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), true, 2)
            
            let context = UIGraphicsGetCurrentContext()!
            
            CGContextSetRGBFillColor(context, 1, 1, 1, 1.0)
            CGContextAddRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height))
            CGContextFillPath(context)
        
            CGContextTranslateCTM(context, 0, rect.size.height-1)
            CGContextScaleCTM(context, 1.0, -1.0)
            
            let line = CTLineCreateWithAttributedString(string)
            CTLineDraw(line, context)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            dispatch_async(dispatch_get_main_queue(), {
                self.backgroundColor = UIColor.redColor()
                self.image = image
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.width, rect.size.height)
                if let b = block {
                    b(size: rect.size)
                }
            })
        }
        
    }
    
}