//
//  AppDelegate.h
//  BackgroundSwitcherMac
//
//  Created by AndrewT on 2014-12-13.
//  Copyright (c) 2014 AndrewT. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSMenu *statusMenu;
    NSStatusItem * statusItem;
    NSImage * statusImage;
    NSImage * statusHighlightImage;
    
}

-(int)getRandomNumberBetween:(int)from to:(int)to;
-(void)setWallpaper:(NSURL *) imageUrl;
-(NSURL*) getFileUrl:(NSString *) fileName;
-(void)wallpaperTimer;
-(void) refreshList;
- (IBAction)changeSubreddits:(id)sender;
-(void)callReddit:(NSString *) subreddit;
-(NSURL *)giveRandomImage;
-(void) deleteFile:(NSString *) imgName;
-(void)saveImageInLocalDirectory:(NSString*)url filename:(NSString *) fileName;

@property (assign) IBOutlet NSWindow * window;

@end

