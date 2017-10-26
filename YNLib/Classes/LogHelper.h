// Tencent is pleased to support the open source community by making Mars available.
// Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.

// Licensed under the MIT License (the "License"); you may not use this file except in 
// compliance with the License. You may obtain a copy of the License at
// http://opensource.org/licenses/MIT

// Unless required by applicable law or agreed to in writing, software distributed under the License is
// distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// either express or implied. See the License for the specific language governing permissions and
// limitations under the License.

//
//  LogHelper.h
//  iOSDemo
//
//  Created by caoshaokun on 16/11/30.
//  Copyright © 2016年 caoshaokun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "appender-swift-bridge.h"

@interface LogHelper : NSObject

+ (void)xdebug:(NSString *)module fileName:(NSString *)fileName lineNumber:(int)lineNumber functionName:(NSString *)functionName message:(NSString *)message;
+ (void)xinfo:(NSString *)module fileName:(NSString *)fileName lineNumber:(int)lineNumber functionName:(NSString *)functionName message:(NSString *)message;
+ (void)xwarning:(NSString *)module fileName:(NSString *)fileName lineNumber:(int)lineNumber functionName:(NSString *)functionName message:(NSString *)message;
+ (void)xerror:(NSString *)module fileName:(NSString *)fileName lineNumber:(int)lineNumber functionName:(NSString *)functionName message:(NSString *)message;

+ (void)debug:(NSString *)module fileName:(const char*)fileName lineNumber:(int)lineNumber functionName:(const char*)functionName message:(NSString *)message;
+ (void)info:(NSString *)module fileName:(const char*)fileName lineNumber:(int)lineNumber functionName:(const char*)functionName message:(NSString *)message;
+ (void)warning:(NSString *)module fileName:(const char*)fileName lineNumber:(int)lineNumber functionName:(const char*)functionName message:(NSString *)message;
+ (void)error:(NSString *)module fileName:(const char*)fileName lineNumber:(int)lineNumber functionName:(const char*)functionName message:(NSString *)message;

@end

#define LogInternalDebug(module, file, line, funcName, format, ...) \
    { NSString *aMessage = [NSString stringWithFormat:format, ##__VA_ARGS__]; \
    [LogHelper debug:module fileName:file lineNumber:line functionName:funcName message:aMessage]; } \

#define LogInternalInfo(module, file, line, funcName, format, ...) \
    { NSString *aMessage = [NSString stringWithFormat:format, ##__VA_ARGS__]; \
    [LogHelper info:module fileName:file lineNumber:line functionName:funcName message:aMessage]; } \

#define LogInternalWarning(module, file, line, funcName, format, ...) \
    { NSString *aMessage = [NSString stringWithFormat:format, ##__VA_ARGS__]; \
    [LogHelper warning:module fileName:file lineNumber:line functionName:funcName message:aMessage]; } \

#define LogInternalError(module, file, line, funcName, format, ...) \
    { NSString *aMessage = [NSString stringWithFormat:format, ##__VA_ARGS__]; \
    [LogHelper error:module fileName:file lineNumber:line functionName:funcName message:aMessage]; } \
