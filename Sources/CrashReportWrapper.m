//
//  CrashReportWrapper.m
//  YNLib
//
//  Created by stoprain on 5/19/16.
//  Copyright © 2016 yunio. All rights reserved.
//

#import "CrashReportWrapper.h"
#import <CrashReporter/CrashReporter.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

#ifndef ddLogLevel
static const int ddLogLevel = DDLogLevelError;
#endif

@implementation CrashReportWrapper

+ (void)enableCrashReport {
    NSError *error;
    [[PLCrashReporter sharedReporter] enableCrashReporterAndReturnError:&error];
    DDLogError(@"enableCrashReport failed %@", error);
}

+ (NSString *)handleCrashReport {
    
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;
    if ([crashReporter hasPendingCrashReport]) {
        crashData = [crashReporter loadPendingCrashReportDataAndReturnError:&error];
        if (crashData == nil) {
            return @"";
        }
        
        PLCrashReport *report = [[PLCrashReport alloc] initWithData:crashData error:&error];
        if (report == nil) {
            return @"";
        }
        
        //[crashReporter purgePendingCrashReport];
        
        NSString *s = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:PLCrashReportTextFormatiOS];
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *crashPath = [cachePath stringByAppendingPathComponent:@"Crash"];
        NSString *u = [[NSUUID UUID].UUIDString stringByAppendingPathExtension:@"crash"];
        NSString *crashLog = [crashPath stringByAppendingPathComponent:u];
        if (![manager fileExistsAtPath:crashPath]) {
            [manager createDirectoryAtPath:crashPath
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
        }
        [s writeToFile:crashLog atomically:YES encoding:NSUTF8StringEncoding error:nil];
        return crashLog;
    }
    
    return @"";
}


@end
