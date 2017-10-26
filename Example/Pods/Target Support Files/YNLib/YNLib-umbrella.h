#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "appender-swift-bridge.h"
#import "LogHelper.h"
#import "LogUtil.h"
#import "RunMode.h"
#import "YNLib.h"

FOUNDATION_EXPORT double YNLibVersionNumber;
FOUNDATION_EXPORT const unsigned char YNLibVersionString[];

