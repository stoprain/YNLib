
#import "appender-swift-bridge.h"
#import <mars/xlog/appender.h>
#import <mars/xlog/xlogger.h>
#import <sys/xattr.h>

@implementation MarsBridge

+ (void)initXlogger: (NSString*)path prefix: (const char*)prefix {
    
    NSString* logPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:path];
    
    // set do not backup for logpath
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    setxattr([logPath UTF8String], attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    // init xlog
    #if DEBUG

    xlogger_SetLevel((TLogLevel)kLevelDebug);
    appender_set_console_log(true);
    #else
   
    xlogger_SetLevel((TLogLevel)kLevelInfo);
    appender_set_console_log(false);
    #endif
    appender_open(kAppednerAsync, [logPath UTF8String], prefix);
    
}

+ (void)flushSyncXlogger {
    appender_flush_sync();
}

+ (void)deinitXlogger {
    appender_close();
}

@end


