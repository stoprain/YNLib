//
//  CTLabel.swift
//  CoreTextTest
//
//  Created by stoprain on 4/14/16.
//  Copyright © 2016 stoprain. All rights reserved.
//

open class CTLabel: UIImageView {
    
    open func updateText(_ string: NSAttributedString, block: ((_ size: CGSize) -> ())? = nil) {
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            
            let r = string.boundingRect(
                with: CGSize.zero,
                options: .usesLineFragmentOrigin,
                context: nil)
            let rect = CGRect(x: 0, y: 0, width: ceil(r.size.width), height: ceil(r.size.height))
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width, height: rect.size.height), true, 2)
            
            let context = UIGraphicsGetCurrentContext()!
            
            context.setFillColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            context.addRect(CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
            context.fillPath()
        
            context.translateBy(x: 0, y: rect.size.height-3)   //HACK offset for chinese character
            context.scaleBy(x: 1.0, y: -1.0)
            
            let line = CTLineCreateWithAttributedString(string)
            CTLineDraw(line, context)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async(execute: {
                self.backgroundColor = UIColor.white
                self.image = image
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: rect.size.width, height: rect.size.height)
                if let b = block {
                    b(rect.size)
                }
            })
        }
        
    }
    
}
