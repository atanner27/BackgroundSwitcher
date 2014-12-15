//
//  AppDelegate.m
//  BackgroundSwitcherMac
//
//  Created by AndrewT on 2014-12-13.
//  Copyright (c) 2014 AndrewT. All rights reserved.
//

#import "AppDelegate.h"

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
    //[statusItem setMenu:statusMenu];
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Open Feedbin" action:@selector(doSomething:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Refresh" action:@selector(doSomethingElse:) keyEquivalent:@""];
   
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [menu addItemWithTitle:@"Quit BackgroundChanger" action:@selector(terminate:) keyEquivalent:@""];
    [statusItem setMenu:menu];
}
- (IBAction)doSomething:(id)sender
{
    NSLog(@"is doing something");
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
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"back1" withExtension:@"jpg"];
    //NSURL *imageURL = [[NSWorkspace sharedWorkspace] desktopImageURLForScreen:curScreen];
    if (![[NSWorkspace sharedWorkspace] setDesktopImageURL:url
                                                 forScreen:curScreen
                                                   options:screenOptions
                                                     error:&error])
    {
        //[self presentError:error];
    }
        
    }
    //for (NSScreen *screen in screens) {
        
        
    //}
    
    [self setWallpaper];
    
    /* setDesktopImageURL:(NSURL *)backImage
forScreen:(NSScreen *)screen
options:(NSDictionary *)options
error:(NSError **)error*/
    
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
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"back1" withExtension:@"jpg"];
        //NSURL *imageURL = [[NSWorkspace sharedWorkspace] desktopImageURLForScreen:curScreen];
        if (![[NSWorkspace sharedWorkspace] setDesktopImageURL:url
                                                     forScreen:curScreen
                                                       options:screenOptions
                                                         error:&error])
        {
            //[self presentError:error];
        }
        
    }
}

- (IBAction)doSomethingElse:(id)sender
{
    NSLog(@"is doing something");
    NSImage * backImage2;
    NSBundle * bundle = [NSBundle mainBundle ];
    
    backImage2 = [[NSImage alloc ] initWithContentsOfFile:[bundle pathForResource:@"back2" ofType:@"jpg"]];
    //SetDes
    
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
