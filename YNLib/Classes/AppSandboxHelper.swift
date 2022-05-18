//
//  AppSandboxHelper.swift
//  YNLib
//
//  Created by stoprain on 10/30/15.
//  Copyright © 2015 stoprain. All rights reserved.
//

import Foundation

/*
refer

https://developer.apple.com/library/ios/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html

*/

@objc
open class AppSandboxHelper: NSObject {
    
    /*! Application Documents directory for critical user data
    * \return path of the Documents directory
    */
    
    open static var documentsPath: String = {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }()
    
    /*! Application Caches directory
    * \return path of the Caches directory
    */
    
    open static var cachesPath: String = {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }()

}
