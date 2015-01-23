//
//  Utility.m
//  BackgroundSwitcherMac
//
//  Created by AndrewT on 2015-01-17.
//  Copyright (c) 2015 AndrewT. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(void) writeToConfig:(NSString *)rawInput
{
    NSString * documentsDirectoryPath = [Utility getImagePaths];
    NSString *fileName = @"config.txt";
    //NSString *imgURL = url;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:filePath];
    
    if(![fileManager fileExistsAtPath:filePath]){
        // file doesn't exist
        NSLog(@"file doesn't exist");
        //Create file
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        
    }
    else{
        // file exist
        NSLog(@"file exists");
    }
    //write your items
    //for every item
    //[@"spaceporn" writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(NSMutableArray *) readFromConfig
{
    NSMutableArray * subreddits;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    subreddits = [NSMutableArray new];
    NSString * filePath = [Utility getImagePaths];
    filePath = [filePath stringByAppendingPathComponent:@"/config.txt"];
    
    if(![fileManager fileExistsAtPath:filePath]){
        //file does not exist
        //create file
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        //write defaults to it
        [@"earthporn" writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [@"spaceporn" writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [subreddits addObject:@"earthporn"];
        [subreddits addObject:@"spaceporn"];
        
    }
    else{
        //file exists, read preferences
        NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
            // Do something
            NSLog(@"%@", line);
            if([line length] > 0)
            {
                [subreddits addObject:line];
            }
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
