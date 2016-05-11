//
//  YNLib.h
//  YNLib
//
//  Created by stoprain on 4/26/16.
//  Copyright © 2016 yunio. All rights reserved.
//

#ifdef ip

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
@import Foundation;
@import UIKit;
#else
@import <Cocoa/Cocoa.h>
#endif

//! Project version number for YNLib.
FOUNDATION_EXPORT double YNLibVersionNumber;

//! Project version string for YNLib.
FOUNDATION_EXPORT const unsigned char YNLibVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <YNLib/PublicHeader.h>

#import <YNLib/RunMode.h>