//
//  SimpleDDLogFormatter.h
//
//  Created by Rain Qian on 11/26/13.
//  Copyright (c) 2013 Yunio. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

@interface SimpleDDLogFormatter : NSObject
    <DDLogFormatter>
{
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}

@property (nonatomic) BOOL lineBreaks;

@end
