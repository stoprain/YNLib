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
    
    func imageByScalingAndCroppingForSize(_ targetSize: CGSize, isShortEdge: Bool? = true) -> UIImage? {
        
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
        var thumbnailPoint = CGPoint.zero
        var shortEdge = true
        if let t = isShortEdge, !t {
            shortEdge = false
        }
        
        if !imageSize.equalTo(targetSize) {
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
        
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaleWidth
        thumbnailRect.size.height = scaleHeight
        
        sourceImage.draw(in: thumbnailRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        if newImage == nil {
            print("could not scale image")
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func loadScreenSizeImageFromPath(_ path: String) -> UIImage? {
        let url = URL(fileURLWithPath: path)
        let screenFrame = UIScreen.main.bounds
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil), let imageInfo = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
            if let pixelHeight = imageInfo[kCGImagePropertyPixelHeight as NSString] as? CGFloat,
                let pixelWidth = imageInfo[kCGImagePropertyPixelWidth as NSString] as? CGFloat {
                let height = pixelHeight * screenFrame.size.width * 2 / pixelWidth
                let options: [NSString: NSObject] = [
                    kCGImageSourceThumbnailMaxPixelSize: NSNumber(value: Float(max(height, screenFrame.size.width*2))),
                    kCGImageSourceCreateThumbnailFromImageAlways: NSNumber(value: true)
                ]
                let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary?).flatMap { UIImage(cgImage: $0) }
                return scaledImage
            }
        }
        return nil
    }
    
}
