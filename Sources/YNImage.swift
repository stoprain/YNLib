//
//  YNImage.swift
//  YNLib
//
//  Created by stoprain on 3/10/16.
//  Copyright © 2016 yunio. All rights reserved.
//

import UIKit

public enum YNImagePlaceHolder {
    case Post, Avatar
    public func imageName() -> String {
        switch self {
        case .Post:     return "PostPlaceholder"
        case .Avatar:   return "AvatarPlaceholder"
        }
    }
}

public enum PhotoType: Int {
    case Avatar
    case Post
    case Category
}

public struct YNImage {
    
    public static var downloadPath = ""

}
