//
//  CrashReportWrapper.h
//  YNLib
//
//  Created by stoprain on 5/19/16.
//  Copyright © 2016 yunio. All rights reserved.
//

@import Foundation;

@interface CrashReportWrapper : NSObject

+ (void)enableCrashReport;
+ (NSString *)handleCrashReport;

@end
