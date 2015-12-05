//
//  ImageCompressor.swift
//  YNLib
//
//  Created by stoprain on 12/5/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import UIKit

public class ImageCompressor {
    
    public class func compressImage(image: UIImage, shortEdge: CGFloat, level: CGFloat) -> NSData {
        var width = image.size.width
        var height = image.size.height
        var ratio: CGFloat = 0
        if width >= height {
            // height is the short edge
            if (height <= shortEdge) {
                return UIImageJPEGRepresentation(image, level)!
            }
            
            ratio = height/shortEdge;
            width = width/ratio;
            height = shortEdge;
        } else {
            if width <= shortEdge {
                return UIImageJPEGRepresentation(image, level)!
            }
            
            ratio = width/shortEdge;
            height = height/ratio;
            width = shortEdge;
        }
        
        //http://stackoverflow.com/questions/6081356/a-thin-whiteline-is-been-added-
        //rounding the value to prevent white line
        let result = image.imageByScalingAndCroppingForSize(CGSizeMake(round(width), round(height)))!
        return UIImageJPEGRepresentation(result, level)!
    }

}