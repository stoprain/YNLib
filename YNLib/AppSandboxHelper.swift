//
//  AppSandboxHelper.swift
//  YNLib
//
//  Created by stoprain on 10/30/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import UIKit

/*
refer

https://developer.apple.com/library/ios/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html

*/

public class AppSandboxHelper {
    
    /*! Application Documents directory for critical user data
    * \return path of the Documents directory
    */
    
    public static var documentsPath: String = {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
    }()
    
    /*! Application Caches directory
    * \return path of the Caches directory
    */
    
    public static var cachesPath: String = {
        return NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first!
    }()

}
