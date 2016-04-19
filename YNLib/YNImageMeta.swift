//
//  YNImageMeta.swift
//  Groubum
//
//  Created by stoprain on 8/22/15.
//  Copyright (c) 2015 yunio. All rights reserved.
//

import UIKit

public class YNImageMeta: NSObject {
    
    public var objectId: String = ""
    public var size = CGSizeZero
    public var type = PhotoType.Post
    public var cornerRadius: CGFloat = 0
    public var borderWidth: CGFloat = 0
    public var borderColorHex = "#ffffff"
    public var cacheKey: String = ""
    public var path: String = ""
    public var placeHolderKey: String = YNImagePlaceHolder.Post.imageName()
    public var waterMark = true
    public override var description: String {
        return self.cacheKey
    }
    
    public func update(s: String) {
        
        self.objectId = s
        
        let suffix = self.size.height.description + self.borderColorHex
        self.cacheKey = self.objectId + suffix
        self.path = YNImage.downloadPath.stringByAppendingString("/\(self.cacheKey)")
        
        if type == .Avatar {
            self.placeHolderKey = YNImagePlaceHolder.Avatar.imageName() + self.borderColorHex
        }
    }
    
    public func copyForQueue() -> YNImageMeta {
        let meta = YNImageMeta()
        meta.objectId = self.objectId
        meta.size = self.size
        meta.type = self.type
        meta.cornerRadius = self.cornerRadius
        meta.borderWidth = self.borderWidth
        meta.borderColorHex = self.borderColorHex
        meta.cacheKey = self.cacheKey
        meta.path = self.path
        meta.placeHolderKey = self.placeHolderKey
        meta.waterMark = self.waterMark
        return meta
    }
    
}
