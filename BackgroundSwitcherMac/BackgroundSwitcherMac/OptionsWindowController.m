//
//  OptionsWindowController.m
//  BackgroundSwitcherMac
//
//  Created by AndrewT on 2015-01-13.
//  Copyright (c) 2015 AndrewT. All rights reserved.
//

#import "OptionsWindowController.h"

@interface OptionsWindowController ()


@end

@implementation OptionsWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)saveClicked:(id)sender {
    
    //parse data
    NSString *myString = [_subreddittext stringValue];
    //update config
    
    //close window
    
    //[self orderOut:nil];
}


@end
