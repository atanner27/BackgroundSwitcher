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
{
    NSMutableArray * urlList;
}

@end

@implementation AppDelegate

@synthesize window;

- (void) awakeFromNib{
    
    //Load up from config files
    
    
    
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
    
    //Make the reddit calls to buld up list of images
    //Need to expand to multiple subreddits
    [self callReddit];
    
    //once have the list of images
    NSInteger index = 0;
    for(NSString * curString in urlList)
    {
        //create a key value mapping with the url as the key and the imagename as value
        NSMutableString * imageName = [NSMutableString stringWithFormat:@"image%ld", (long)index];
        [imageName appendFormat:@".png"];
        //Save all of the local images
        //[self saveImageInLocalDirectory:curString filename: imageName ];
        index++;
    }
    //Must download the files to temp
    //[self saveImageInLocalDirectory ];
    //dont knwo if should be giving it current image url
    //or if should be giving it the whole structure
    
    
    
    //wrap the selector in a function that handles cycling through images/get new
    //if number of images left to be cycled through is  > 4
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
         NSURL *url = [[NSURL alloc] initWithString:@"http://i.imgur.com/oafDaqu.jpg"];
        
        //NSURL *imageURL = [[NSWorkspace sharedWorkspace] desktopImageURLForScreen:curScreen];
        
        //Use reddit url
        
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

-(NSURL *)giveRandomImage
{
    int randomNumber = [self getRandomNumberBetween:1 to:2];
    NSString * imageName = @"";
    //NSLog([NSString stringWithFormat:@"%d", randomNumber] );
    if(randomNumber == 1)
    {
        imageName = @"back1";
    }
    else
    {
        imageName = @"back2";
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:@"jpg"];
    
    return url;
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

-(void)saveImageInLocalDirectory:(NSString*)url filename:(NSString *) fileName
{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imgName = fileName;
    NSString *imgURL = url;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writablePath = [documentsDirectoryPath stringByAppendingPathComponent:imgName];
    
    if(![fileManager fileExistsAtPath:writablePath]){
        // file doesn't exist
        NSLog(@"file doesn't exist");
        //save Image From URL
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString: imgURL]];
        
        NSError *error = nil;
        [data writeToFile:[documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imgName]] options:NSAtomicWrite error:&error];
        
        if (error) {
            NSLog(@"Error Writing File : %@",error);
        }else{
            NSLog(@"Image %@ Saved SuccessFully",imgName);
        }
    }
    else{
        // file exist
        NSLog(@"file exist");
    }
}

-(void)callReddit
{
//just give your URL instead of my URL
NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL  URLWithString:@"http://www.reddit.com/r/earthporn/hot.json"]];

[request setHTTPMethod:@"GET"];

[request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
[request setValue:@"BackgroundSwitcher Agent" forHTTPHeaderField:@"User-Agent"];
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
    //each element of the array is a post
    for (NSDictionary * groupDic in array) {
    
        NSArray *dataObjs = [groupDic objectForKey:@"data"];
        NSDictionary *dict = [groupDic objectForKey:@"data"];
        NSString * url = [dict objectForKey:@"url"];
        
        if ([url rangeOfString:@"imgur"].location == NSNotFound) {
            //Not from imgur
            NSLog(@"string does not contain bla");
        } else {
            //from imgur. use it
            //Add the url to the global list
            [urlList addObject:url];
            NSLog(@"string contains bla!");
        }
        
    }
    
    
}


@end
