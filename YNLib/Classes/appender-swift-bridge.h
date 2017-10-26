
#include <stdio.h>
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, XloggerType) {
    debug = 1,
    info = 2,
    warning = 3,
    error = 4,
};

@interface MarsBridge: NSObject

//+ (void)initXlogger: (XloggerType)debugLevel releaseLevel: (XloggerType)releaseLevel path: (NSString*)path prefix: (const char*)prefix;
+ (void)initXlogger: (NSString*)path prefix: (const char*)prefix;
+ (void)flushSyncXlogger;
+ (void)deinitXlogger;

@end


