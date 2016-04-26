//
//  SimpleDDLogFormatter.m
//
//  Created by Rain Qian on 11/26/13.
//  Copyright (c) 2013 Yunio. All rights reserved.
//

#import "SimpleDDLogFormatter.h"
#import <libkern/OSAtomic.h>

#define dateFormatString @"yyyy/MM/dd HH:mm:ss:SSS"
#define FilenameSpace   20

#define L_BLUE          "\e[0;34m"
#define L_CYAN          "\e[0;36m"
#define L_YELLOW        "\e[0;33m"
#define L_RED           "\e[0;31m"

static NSString *ErrorFormat;
static NSString *WarnFormat;
static NSString *InfoFormat;
static NSString *DebugFormat;
static NSString *VerboseFormat;
static NSString *EndFormat;

@implementation SimpleDDLogFormatter

+ (void)initialize
{
    
//#if !(TARGET_IPHONE_SIMULATOR)
//    BOOL result = NO;
//
//    struct kinfo_proc procInfo;
//    size_t structSize = sizeof(procInfo);
//    int mib[] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()};
//
//    if(sysctl(mib, sizeof(mib)/sizeof(*mib), &procInfo, &structSize, NULL, 0) != 0)
//    {
//        DDLogError(@"sysctl: %s", strerror(errno));
//        result = NO;
//    }
//    else
//    {
//        result = (procInfo.kp_proc.p_flag & P_TRACED) != 0;
//    }
//
//    if (result)
//    {
//        ErrorFormat = [NSString stringWithFormat:@"%sE", L_RED];
//        WarnFormat = [NSString stringWithFormat:@"%sW", L_YELLOW];
//        InfoFormat = [NSString stringWithFormat:@"%sI", L_CYAN];
//        DebugFormat = [NSString stringWithFormat:@"%sD", L_BLUE];
//        EndFormat = @"\e[m";
//    }
//    else
//#endif
//    {
        ErrorFormat = @"E";
        WarnFormat = @"W";
        InfoFormat = @"I";
        DebugFormat = @"D";
        EndFormat = @"";
//    }
    
    VerboseFormat = @"V";
}

- (instancetype)init
{
    if ((self = [super init]))
    {
        self.lineBreaks = YES;
    }
    
    return self;
}

- (NSString *)stringFromDate:(NSDate *)date
{
    int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);
    
    if (loggerCount <= 1)
    {
        // Single-threaded mode.
        
        if (threadUnsafeDateFormatter == nil)
        {
            threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [threadUnsafeDateFormatter setDateFormat:dateFormatString];
        }
        
        return [threadUnsafeDateFormatter stringFromDate:date];
    }
    else
    {
        // Multi-threaded mode.
        // NSDateFormatter is NOT thread-safe.
        
        NSString *key = @"MyCustomFormatter_NSDateFormatter";
        
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        
        if (dateFormatter == nil)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [dateFormatter setDateFormat:dateFormatString];
            
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *logLevel;
    switch (logMessage.flag)
    {
        case DDLogFlagError     : logLevel = ErrorFormat; break;
        case DDLogFlagWarning   : logLevel = WarnFormat; break;
        case DDLogFlagInfo      : logLevel = InfoFormat; break;
        case DDLogFlagDebug     : logLevel = DebugFormat; break;
        default                 : logLevel = VerboseFormat; break;
    }

    NSString *logMsg = logMessage.message;
    
//    NSString *filename = [NSString stringWithUTF8String:logMessage->file].lastPathComponent;
//    if (filename.length < FilenameSpace)
//    {
//        filename = [filename stringByPaddingToLength:FilenameSpace withString:@" " startingAtIndex:0];
//    }
//    else
//    {
//        filename = [filename substringToIndex:FilenameSpace];
//    }
    
    NSString *dateAndTime = [self stringFromDate:(logMessage.timestamp)];
//    return [NSString stringWithFormat:@"%@ %@ | %@ + %4d | %5d | %@%@%@",
//            logLevel,
//            dateAndTime,
//            filename,
//            logMessage->lineNumber,
//            logMessage->machThreadID,
//            logMsg,
//            EndFormat,
//            _lineBreaks?@"\n":@""];
    return [NSString stringWithFormat:@"%@ %@ | %@%@",
            logLevel,
            dateAndTime,
            logMsg,
            EndFormat];
}

- (void)didAddToLogger:(id <DDLogger>)logger
{
    OSAtomicIncrement32(&atomicLoggerCount);
}
- (void)willRemoveFromLogger:(id <DDLogger>)logger
{
    OSAtomicDecrement32(&atomicLoggerCount);
}

@end
