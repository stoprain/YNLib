//
//  ScrollHandle.swift
//  YNLib
//
//  Created by stoprain on 4/6/16.
//  Copyright © 2016 stoprain. All rights reserved.
//

public protocol ScrollHandleDelegate: NSObjectProtocol {
    func scrollHandleChange(_ progress: CGFloat)
}

open class ScrollHandle: UIView {
    
    let ScrollHandleDuration = 1.5
    let ScrollHandleActiveHeightMultiple = 3

    let handle = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    open weak var delegate: ScrollHandleDelegate?
    open var progress: CGFloat = 0 {
        didSet {
            if !self.isDragging {
                var y = (self.frame.size.height-self.handle.frame.size.height)*progress+self.handle.frame.size.height/2
                y = max(self.handle.frame.size.height/2, y)
                y = min(self.frame.size.height-self.handle.frame.size.height/2, y)
                self.handle.center = CGPoint(x: self.handle.center.x, y: y)
                if self.handle.superview == nil {
                    self.handle.backgroundColor = UIColor.green
                    self.addSubview(self.handle)
                }
            }
        }
    }
    var isDragging = false
    var lastY: CGFloat = 0
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            let tl = t.location(in: self)
            if self.handle.frame.contains(tl) {
                lastY = tl.y
                self.handle.backgroundColor = UIColor.red
                self.isDragging = true
            }
        }
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handle.backgroundColor = UIColor.green
        self.isDragging = false
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handle.backgroundColor = UIColor.green
        self.isDragging = false
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard self.isDragging else {
            return
        }
        
        if let t = touches.first {
            let tl = t.location(in: self)
            lastY = tl.y
            lastY = max(self.handle.frame.size.height/2, lastY)
            lastY = min(self.frame.size.height-self.handle.frame.size.height/2, lastY)
            
            let y = (lastY-self.handle.frame.size.height/2)/(CGFloat)(self.frame.size.height-self.handle.frame.size.height)
            self.handle.backgroundColor = UIColor.red
            
            self.handle.center = CGPoint(x: self.handle.center.x, y: lastY)
            self.delegate?.scrollHandleChange(y)
        }
    }
    
}
