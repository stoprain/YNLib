//
//  RunMode.h
//  TwoTripleThree
//
//  Created by stoprain on 12/4/15.
//  Copyright © 2015 yunio. All rights reserved.
//

@import Foundation;

@interface RunMode : NSObject

+ (BOOL)isDebug;
+ (BOOL)isProd;

@end
