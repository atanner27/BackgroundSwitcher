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

- (IBAction)doSomething:(id)sender;
-(void)setWallpaper;

@property (assign) IBOutlet NSWindow * window;

@end

