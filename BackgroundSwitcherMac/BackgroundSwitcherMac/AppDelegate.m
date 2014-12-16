//
//  AppDelegate.m
//  BackgroundSwitcherMac
//
//  Created by AndrewT on 2014-12-13.
//  Copyright (c) 2014 AndrewT. All rights reserved.
//

#import "AppDelegate.h"
#import "OptionsWindowcontroller.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window;

- (void) awakeFromNib{
    
    //statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength]]
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSBundle * bundle = [NSBundle mainBundle ];
    
    statusImage = [[NSImage alloc ] initWithContentsOfFile:[bundle pathForResource:@"icon" ofType:@"png"]];
    
    [statusItem setImage:statusImage];
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Change Background" action:@selector(doSomething:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Change Subreddits" action:@selector(doSomethingElse:) keyEquivalent:@""];
   
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [menu addItemWithTitle:@"Quit BackgroundChanger" action:@selector(terminate:) keyEquivalent:@""];
    [statusItem setMenu:menu];
    
    
    //set up timer
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(setWallpaper)
                                   userInfo:nil
                                    repeats:YES];
}
- (IBAction)doSomething:(id)sender
{
    NSLog(@"is doing something");
    
    [self setWallpaper];
}

-(void)setWallpaper
{
    NSImage * backImage;
    NSBundle * bundle = [NSBundle mainBundle ];
    
    backImage = [[NSImage alloc ] initWithContentsOfFile:[bundle pathForResource:@"back1" ofType:@"jpg"]];
    
    NSArray *screens = [NSScreen screens];
    NSScreen *curScreen;
    NSUInteger screenIndex = 1;
    for (curScreen in screens)
    {
        NSError *error = nil;
        // get the current screen options
        NSMutableDictionary *screenOptions =
        
        [[[NSWorkspace sharedWorkspace] desktopImageOptionsForScreen:curScreen] mutableCopy];
        //NSURL *url = @"";
        int randomNumber = [self getRandomNumberBetween:1 to:2];
        NSString * imageName = @"";
        NSLog([NSString stringWithFormat:@"%d", randomNumber] );
        if(randomNumber == 1)
        {
           imageName = @"back1";
        }
        else
        {
           imageName = @"back2";
        }
        NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:@"jpg"];
        //NSURL *imageURL = [[NSWorkspace sharedWorkspace] desktopImageURLForScreen:curScreen];
        if (![[NSWorkspace sharedWorkspace] setDesktopImageURL:url
                                                     forScreen:curScreen
                                                       options:screenOptions
                                                         error:&error])
        {
            //Give an error message/ try dif background?
            //[self presentError:error];
        }
        
    }
}

- (IBAction)doSomethingElse:(id)sender
{
    NSLog(@"is doing something");
    //[self setWallpaper];
    
    /*ViewControllerMonitorMenu *monitorMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerMonitorMenu"];
     [self presentViewController:monitorMenuViewController animated:NO completion:nil];
     */

    //[NSApplication presentViewController:OptionsWindowcontroller animated:YES ^{}];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

@end
