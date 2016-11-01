//
//  UIView+Frame.swift
//  TwoTripleThree
//
//  Created by Pegaiur on 15/11/23.
//  Copyright © 2015年 yunio. All rights reserved.
//

import Foundation

public extension UIView {
    
    //  frame setting
    
    func setFrame(_ centerX:CGFloat,centerY:CGFloat,width:CGFloat,height:CGFloat) {
        self.frame = CGRect(x: centerX - width/2, y: centerY - height/2, width: width, height: height)
    }
    
    //  size setting
    
    func setSizeByWidth(_ width:CGFloat) {
        self.frame = CGRect(
            x: self.frame.origin.x,
            y: self.frame.origin.y,
            width: width,
            height: self.frame.size.height)
    }
    
    func setSizeByHeight(_ height:CGFloat) {
        self.frame = CGRect(
            x: self.frame.origin.x,
            y: self.frame.origin.y,
            width: self.frame.size.width,
            height: height)
    }
    
    func setSize(_ width:CGFloat,heigth:CGFloat) {
        self.frame = CGRect(
            x: self.frame.origin.x,
            y: self.frame.origin.y,
            width: width,
            height: heigth)
    }
    
    func setSizeForAnimation(_ width:CGFloat,heigth:CGFloat) {
        self.frame = CGRect(
            x: self.frame.origin.x - (width - self.frame.width)/2,
            y: self.frame.origin.y - (heigth - self.frame.height)/2,
            width: width,
            height: heigth)
    }
    
    func setSizeByMultiple(_ multiple:CGFloat) {
        self.frame = CGRect(
            x: self.frame.origin.x,
            y: self.frame.origin.y,
            width: self.frame.size.width * multiple,
            height: self.frame.size.height * multiple)
    }
    
    func setSizeByMultipleForAnimation(_ multiplier:CGFloat) {
        self.frame = CGRect(
            x: self.frame.origin.x - (self.frame.width * (multiplier - 1))/2,
            y: self.frame.origin.y - (self.frame.height * (multiplier - 1))/2,
            width: self.frame.size.width * multiplier,
            height: self.frame.size.height * multiplier)
    }
    
    //  origin setting
    
    func setOriginX(_ x:CGFloat) {
        self.frame = CGRect(
            x: x,
            y: self.frame.origin.y,
            width: self.frame.size.width,
            height: self.frame.size.height)
    }
    
    func setOriginXByPlus(_ deltaX:CGFloat) {
        self.frame = CGRect(
            x: self.frame.origin.x + deltaX,
            y: self.frame.origin.y,
            width: self.frame.size.width,
            height: self.frame.size.height)
    }
    
    func setOriginY(_ y:CGFloat) {
        self.frame = CGRect(
            x: self.frame.origin.x,
            y: y,
            width: self.frame.size.width,
            height: self.frame.size.height)
    }
    
    func setOriginYByPlus(_ deltaY:CGFloat) {
        self.frame = CGRect(
            x: self.frame.origin.x,
            y: self.frame.origin.y + deltaY,
            width: self.frame.size.width,
            height: self.frame.size.height)
    }
    
    func setOrigin(_ x:CGFloat,y:CGFloat) {
        self.frame = CGRect(
            x: x,
            y: y,
            width: self.frame.size.width,
            height: self.frame.size.height)
    }
    
    //  rotation
    
    func rotateByAngle(_ angle:CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: (angle * CGFloat(M_PI)) / 180.0)
    }
    
    func scaleByMultiple(_ deltaX:CGFloat,deltaY:CGFloat) {
        self.transform = CGAffineTransform(scaleX: deltaX, y: deltaY)
    }
    
    //  get method
    
    func getX() -> CGFloat {
        return self.frame.origin.x
    }
    
    func getY() -> CGFloat {
        return self.frame.origin.y
    }
    
    func getHeight() -> CGFloat {
        return self.frame.height
    }
    
    func getWidth() -> CGFloat {
        return self.frame.width
    }
    
}
