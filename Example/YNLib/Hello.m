//
//  Hello.m
//  YNLib
//
//  Created by stoprain on 18/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

#import "Hello.h"
@import YNLib;

@implementation Hello

+ (void)oclogtest {
    logDebug(@"oclogtest debug %@ %d", @"hello", 1);
    logInfo(@"oclogtest info %@ %d", @"world", 3);
    logWarning(@"oclogtest warning %@ %d", @"hi", 4);
    logError(@"oclogtest error %@ %d", @"error", 5);

}

@end
