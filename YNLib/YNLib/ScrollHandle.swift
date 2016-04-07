//
//  ScrollHandle.swift
//  YNLib
//
//  Created by stoprain on 4/6/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import UIKit

public protocol ScrollHandleDelegate: NSObjectProtocol {
    func scrollHandleChange(progress: CGFloat)
}

public class ScrollHandle: UIView {
    
    let ScrollHandleDuration = 1.5
    let ScrollHandleActiveHeightMultiple = 3

    let handle = UIImageView(frame: CGRectMake(0, 0, 44, 44))
    public weak var delegate: ScrollHandleDelegate?
    public var progress: CGFloat = 0 {
        didSet {
            if !self.isDragging {
                var y = (self.frame.size.height-self.handle.frame.size.height)*progress+self.handle.frame.size.height/2
                y = max(self.handle.frame.size.height/2, y)
                y = min(self.frame.size.height-self.handle.frame.size.height/2, y)
                self.handle.center = CGPointMake(self.handle.center.x, y)
                if self.handle.superview == nil {
                    self.handle.backgroundColor = UIColor.greenColor()
                    self.addSubview(self.handle)
                }
            }
        }
    }
    var isDragging = false
    var lastY: CGFloat = 0
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let t = touches.first {
            let tl = t.locationInView(self)
            if CGRectContainsPoint(self.handle.frame, tl) {
                lastY = tl.y
                self.handle.backgroundColor = UIColor.redColor()
                self.isDragging = true
            }
        }
    }
    
    override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.handle.backgroundColor = UIColor.greenColor()
        self.isDragging = false
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.handle.backgroundColor = UIColor.greenColor()
        self.isDragging = false
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard self.isDragging else {
            return
        }
        
        if let t = touches.first {
            let tl = t.locationInView(self)
            lastY = tl.y
            lastY = max(self.handle.frame.size.height/2, lastY)
            lastY = min(self.frame.size.height-self.handle.frame.size.height/2, lastY)
            
            let y = (lastY-self.handle.frame.size.height/2)/(CGFloat)(self.frame.size.height-self.handle.frame.size.height)
            self.handle.backgroundColor = UIColor.redColor()
            
            self.handle.center = CGPointMake(self.handle.center.x, lastY)
            self.delegate?.scrollHandleChange(y)
        }
    }
    
}
