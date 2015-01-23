//
//  OptionsWindowController.h
//  BackgroundSwitcherMac
//
//  Created by AndrewT on 2015-01-13.
//  Copyright (c) 2015 AndrewT. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OptionsWindowController : NSWindowController
@property (weak) IBOutlet NSTextField *subreddittext;

@property (weak) IBOutlet NSButton *saveButton;
- (IBAction)saveClicked:(id)sender;
@end
