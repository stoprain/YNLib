//
//  RunMode.m
//  TwoTripleThree
//
//  Created by stoprain on 12/4/15.
//  Copyright © 2015 yunio. All rights reserved.
//

#import "RunMode.h"

@implementation RunMode

+ (BOOL)isDebug {
    
#ifdef DEBUG
    return true;
#else
    return false;
#endif
}

+ (BOOL)isProd {
    return ![self isDebug];
}

@end
