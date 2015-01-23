//
//  Utility.m
//  BackgroundSwitcherMac
//
//  Created by AndrewT on 2015-01-17.
//  Copyright (c) 2015 AndrewT. All rights reserved.
//

#import "Utility.h"

@implementation Utility


-(void) writeToConfig:(NSString *)rawInput
{
    // grab your file
    /*NSMutableArray *data = [[rawInput componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]] mutableCopy];
    for (int i = 0; i < [data count]; i++)
    {
        [data replaceObjectAtIndex: i
                        withObject: [[data objectAtIndex: i] componentsSeparatedByString: @","]];
    }*/
    
    //write the string to the file
    
    
    //save content to the documents directory
    /*[rawInput writeToFile:fileName
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];*/
}

+(NSMutableArray *) readFromConfig
{
    NSMutableArray * subreddits;
    subreddits = [NSMutableArray new];
    NSString * filePath = [Utility getImagePaths];
    filePath = [filePath stringByAppendingPathComponent:@"/config/config.txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        // Do something
        NSLog(@"%@", line);
        if([line length] > 0)
        {
            [subreddits addObject:line];
        }
    }
    return subreddits;
}

+(NSString * ) getImagePaths
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString * imageDir = @"/backgroundimages";
    NSString *imageDirPath = [documentsDirectory stringByAppendingPathComponent:imageDir];
    
    return imageDirPath;
}


@end
