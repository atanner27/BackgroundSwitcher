//
//  Utility.h
//  BackgroundSwitcherMac
//
//  Created by AndrewT on 2015-01-17.
//  Copyright (c) 2015 AndrewT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
+(NSMutableArray *) readFromConfig;
+(NSString * ) getImagePaths;
+(void) writeToConfig:(NSString *)rawInput;
@end
