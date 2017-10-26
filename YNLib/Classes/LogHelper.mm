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
//  LogHelper.m
//  iOSDemo
//
//  Created by caoshaokun on 16/11/30.
//  Copyright © 2016年 caoshaokun. All rights reserved.
//

#import "LogHelper.h"

#import <mars/xlog/xlogger.h>
#import <mars/xlog/xloggerbase.h>

static NSUInteger g_processID = 0;

@implementation LogHelper

+ (void)logWithLevel:(TLogLevel)logLevel moduleName:(const char*)moduleName fileName:(const char*)fileName lineNumber:(int)lineNumber funcName:(const char*)funcName message:(NSString *)message {
    XLoggerInfo info;
    info.level = logLevel;
    info.tag = moduleName;
    info.filename = fileName;
    info.func_name = funcName;
    info.line = lineNumber;
    gettimeofday(&info.timeval, NULL);
    info.tid = (uintptr_t)[NSThread currentThread];
    info.maintid = (uintptr_t)[NSThread mainThread];
    info.pid = g_processID;
    xlogger_Write(&info, message.UTF8String);
}

+ (void)logWithLevel:(TLogLevel)logLevel moduleName:(const char*)moduleName fileName:(const char*)fileName lineNumber:(int)lineNumber funcName:(const char*)funcName format:(NSString *)format, ... {
    if ([self shouldLog:logLevel]) {
        va_list argList;
        va_start(argList, format);
        NSString* message = [[NSString alloc] initWithFormat:format arguments:argList];
        [self logWithLevel:logLevel moduleName:moduleName fileName:fileName lineNumber:lineNumber funcName:funcName message:message];
        va_end(argList);
    }
}

+ (BOOL)shouldLog:(int)level {
    return YES;
}

+ (void)xdebug:(NSString *)module fileName:(NSString *)fileName lineNumber:(int)lineNumber functionName:(NSString *)functionName message:(NSString *)message {
    [LogHelper logWithLevel:kLevelDebug moduleName:module.UTF8String fileName:fileName.UTF8String lineNumber:lineNumber funcName:functionName.UTF8String message:message];
}

+ (void)xinfo:(NSString *)module fileName:(NSString *)fileName lineNumber:(int)lineNumber functionName:(NSString *)functionName message:(NSString *)message {
        [LogHelper logWithLevel:kLevelInfo moduleName:module.UTF8String fileName:fileName.UTF8String lineNumber:lineNumber funcName:functionName.UTF8String message:message];
}

+ (void)xwarning:(NSString *)module fileName:(NSString *)fileName lineNumber:(int)lineNumber functionName:(NSString *)functionName message:(NSString *)message {
        [LogHelper logWithLevel:kLevelWarn moduleName:module.UTF8String fileName:fileName.UTF8String lineNumber:lineNumber funcName:functionName.UTF8String message:message];
}

+ (void)xerror:(NSString *)module fileName:(NSString *)fileName lineNumber:(int)lineNumber functionName:(NSString *)functionName message:(NSString *)message {
        [LogHelper logWithLevel:kLevelError moduleName:module.UTF8String fileName:fileName.UTF8String lineNumber:lineNumber funcName:functionName.UTF8String message:message];
}


+ (void)debug:(NSString *)module fileName:(const char*)fileName lineNumber:(int)lineNumber functionName:(const char*)functionName message:(NSString *)message {
    [LogHelper logWithLevel:kLevelDebug moduleName:module.UTF8String fileName:fileName lineNumber:lineNumber funcName:functionName message:message];
}

+ (void)info:(NSString *)module fileName:(const char*)fileName lineNumber:(int)lineNumber functionName:(const char*)functionName message:(NSString *)message {
    [LogHelper logWithLevel:kLevelInfo moduleName:module.UTF8String fileName:fileName lineNumber:lineNumber funcName:functionName message:message];
}

+ (void)warning:(NSString *)module fileName:(const char*)fileName lineNumber:(int)lineNumber functionName:(const char*)functionName message:(NSString *)message {
    [LogHelper logWithLevel:kLevelWarn moduleName:module.UTF8String fileName:fileName lineNumber:lineNumber funcName:functionName message:message];
}

+ (void)error:(NSString *)module fileName:(const char*)fileName lineNumber:(int)lineNumber functionName:(const char*)functionName message:(NSString *)message {
    [LogHelper logWithLevel:kLevelError moduleName:module.UTF8String fileName:fileName lineNumber:lineNumber funcName:functionName message:message];
}

//+ (void)level:(int)level module:(NSString *)module fileName:(const char*)fileName lineNumber:(int)lineNumber functionName:(const char*)functionName message:(NSString *)message {
//    if ([self shouldLog:TLogLevel(level)]) {
//        [self logWithLevel:TLogLevel(level) moduleName:module.UTF8String fileName:fileName lineNumber:lineNumber funcName:functionName message:message];
//    }
//}

@end
