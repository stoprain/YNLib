//
//  ImageUtils.swift
//  YNLib
//
//  Created by stoprain on 11/9/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import Foundation
import ImageIO

public extension UIImage {
    
    func imageByScalingAndCroppingForSize(targetSize: CGSize, isShortEdge: Bool? = true) -> UIImage? {
        
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
        var shortEdge = true
        if let t = isShortEdge where !t {
            shortEdge = false
        }
        
        if !CGSizeEqualToSize(imageSize, targetSize) {
            let widthFactor = targetWidth/width
            let heightFactor = targetHeight/height
            if widthFactor > heightFactor {
                scaleFactor = shortEdge ? widthFactor : heightFactor
            } else {
                scaleFactor = shortEdge ? heightFactor : widthFactor
            }
            scaleWidth = width*scaleFactor
            scaleHeight = height*scaleFactor
            
            if widthFactor > heightFactor {
                if shortEdge {
                    thumbnailPoint.y = (targetHeight-scaleHeight)*0.5
                } else {
                    thumbnailPoint.x = (targetWidth-scaleWidth)*0.5
                }
            } else {
                if widthFactor < heightFactor {
                    if shortEdge {
                        thumbnailPoint.x = (targetWidth-scaleWidth)*0.5
                    } else {
                        thumbnailPoint.y = (targetHeight-scaleHeight)*0.5
                    }
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
    
    class func loadScreenSizeImageFromPath(path: String) -> UIImage? {
        let url = NSURL(fileURLWithPath: path)
        let screenFrame = UIScreen.mainScreen().bounds
        if let imageSource = CGImageSourceCreateWithURL(url, nil), imageInfo = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
            if let pixelHeight = imageInfo[kCGImagePropertyPixelHeight as String] as? CGFloat,
                pixelWidth = imageInfo[kCGImagePropertyPixelWidth as String] as? CGFloat {
                let height = pixelHeight * screenFrame.size.width * 2 / pixelWidth
                let options: [NSString: NSObject] = [
                    kCGImageSourceThumbnailMaxPixelSize: max(height, screenFrame.size.width*2),
                    kCGImageSourceCreateThumbnailFromImageAlways: true
                ]
                let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options).flatMap { UIImage(CGImage: $0) }
                return scaledImage
            }
        }
        return nil
    }
    
}