//
//  ImageCompressor.swift
//  YNLib
//
//  Created by stoprain on 12/5/15.
//  Copyright © 2015 stoprain. All rights reserved.
//

open class ImageCompressor {
    
    /**
     Compress image to jpeg data
     
     - parameter image:     source image
     - parameter shortEdge: short edge
     - parameter level:     jpeg compress level
     
     - returns: jpeg data
     */
    
    open class func compressImage(_ image: UIImage, shortEdge: CGFloat, level: CGFloat) -> Data {
        var width = image.size.width
        var height = image.size.height
        var ratio: CGFloat = 0
        if width >= height {
            // height is the short edge
            if (height <= shortEdge) {
                return image.jpegData(compressionQuality: level)!
            }
            
            ratio = height/shortEdge;
            width = width/ratio;
            height = shortEdge;
        } else {
            if width <= shortEdge {
                return image.jpegData(compressionQuality: level)!
            }
            
            ratio = width/shortEdge;
            height = height/ratio;
            width = shortEdge;
        }
        
        //http://stackoverflow.com/questions/6081356/a-thin-whiteline-is-been-added-
        //rounding the value to prevent white line
        let result = image.imageByScalingAndCroppingForSize(CGSize(width: round(width), height: round(height)))!
        return result.jpegData(compressionQuality: level)!
    }

}
