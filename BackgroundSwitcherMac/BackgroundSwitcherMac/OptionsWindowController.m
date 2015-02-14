//
//  OptionsWindowController.m
//  BackgroundSwitcherMac
//
//  Created by AndrewT on 2015-01-13.
//  Copyright (c) 2015 AndrewT. All rights reserved.
//

#import "OptionsWindowController.h"
#import "Utility.h"
#import "AppDelegate.h"
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
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    
    //appDelegate subreddits]
    /*let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let aVariable = appDelegate.someVariable*/
    /*MainClass *appDelegate = (MainClass *)[[UIApplication sharedApplication] delegate];
     
     [appDelegate.viewController someMethod];*/
    /*MainClass *appDelegate = (MainClass *)[[[NSApplication sharedApplication] delegate]];*/
    
    
    //update config
    [Utility writeToConfig:myString];
    //close window
    
    //[self orderOut:nil];
    //call app delegate read config
    AppDelegate * testing = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    [testing.getRandomNumberBetween];
}


@end
