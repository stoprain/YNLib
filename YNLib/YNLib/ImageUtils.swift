//
//  ImageUtils.swift
//  YNLib
//
//  Created by stoprain on 11/9/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import Foundation


public extension UIImage {
    
    public func imageByScalingAndCroppingForSize(targetSize: CGSize) -> UIImage? {

        let sourceImage = self
        var newImage: UIImage?
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor: CGFloat = 0
        var scaleWidth = targetWidth
        var scaleHeight = targetHeight
        var thumbnailPoint = CGPointZero
        
        if !CGSizeEqualToSize(imageSize, targetSize) {
            let widthFactor = targetWidth/width
            let heightFactor = targetHeight/height
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }
            scaleWidth = width*scaleFactor
            scaleHeight = height*scaleFactor
            
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight-scaleHeight)*0.5
            } else {
                if widthFactor < heightFactor {
                    thumbnailPoint.x = (targetWidth-scaleWidth)*0.5
                }
            }
        }
        
        UIGraphicsBeginImageContext(targetSize)
        
        var thumbnailRect = CGRectZero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaleWidth
        thumbnailRect.size.height = scaleHeight
        
        sourceImage.drawInRect(thumbnailRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        if newImage == nil {
            print("could not scale image")
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}