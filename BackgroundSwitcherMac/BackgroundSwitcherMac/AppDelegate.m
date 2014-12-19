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
    
    [self callUrl];
    
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
    [NSTimer scheduledTimerWithTimeInterval:10.0
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

-(void)callUrl
{
//just give your URL instead of my URL
NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL  URLWithString:@"http://www.reddit.com/r/earthporn/hot.json"]];

[request setHTTPMethod:@"GET"];

[request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];

NSError *err;

NSURLResponse *response;

NSData *responseData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&response error:&err];

//You need to check response.Once you get the response copy that and paste in ONLINE JSON VIEWER.If you do this clearly you can get the correct results.

//After that it depends upon the json format whether it is DICTIONARY or ARRAY

NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options: NSJSONReadingMutableContainers error: &err];

    //NSLog(jsonArray);
    
    NSArray *array=[[jsonArray objectForKey:@"data"]objectForKey:@"children"];
    //start parsing it down
    NSDictionary * testing = [jsonArray objectForKey:@"sadas"];
    
    //NSArray * smallerArray = [array objectForKey:@"sda"];
    for (NSDictionary * groupDic in array) {
    
        NSArray *dataObjs = [groupDic objectForKey:@"data"];
        
        
        //NSLog([groupDic objectForKey:@"data"]);
        for(NSDictionary * currentPost in dataObjs)
        {
            
            NSLog(@"%@", [currentPost objectForKey:@"url"]);
                   
            //NSLog(currentPost.)
        }
        
        
    }
    /*for (NSString* currentString in array)
    {
        NSLog(currentString);
    }*/
    
    
}


@end
