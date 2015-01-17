//
//  AppDelegate.m
//  BackgroundSwitcherMac
//
//  Created by AndrewT on 2014-12-13.
//  Copyright (c) 2014 AndrewT. All rights reserved.
//

#import "AppDelegate.h"
#import "OptionsWindowController.h"

@interface AppDelegate ()
{
    NSMutableArray * urlList;
    NSMutableDictionary * finalUrlList;
    NSMutableArray * subreddits;
    NSMutableArray * toBeDeleted;
    NSTimer * Timer;
}

@property (strong) OptionsWindowController *thing;
@end

@implementation AppDelegate

@synthesize window;

- (void) awakeFromNib{
    //data
    urlList = [NSMutableArray new];
    subreddits = [NSMutableArray new];
    toBeDeleted = [NSMutableArray new];
    finalUrlList = [NSMutableDictionary new];
    //Load up from config files
    [subreddits addObject:@"earthporn"];
    //[subreddits addObject:@"spaceporn"];
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSBundle * bundle = [NSBundle mainBundle ];
    
    statusImage = [[NSImage alloc ] initWithContentsOfFile:[bundle pathForResource:@"icon" ofType:@"png"]];
    
    [statusItem setImage:statusImage];
    NSMenu *menu = [[NSMenu alloc] init];
    
    [menu addItemWithTitle:@"Change Subreddits" action:@selector(changeSubreddits:) keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    
    [menu addItemWithTitle:@"Change Picture" action:@selector(changePicture:) keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [menu addItemWithTitle:@"Quit BackgroundChanger" action:@selector(terminate:) keyEquivalent:@""];
    [statusItem setMenu:menu];
 
    //make the storage folder if it does not exist
    [self makeFolder];
    //Refresh the list of images/get new images
    [self refreshList];
    
    //wrap the selector in a function that handles cycling through images/get new
    //if number of images left to be cycled through is  > 4
    //set up timer
    Timer = [NSTimer scheduledTimerWithTimeInterval:1200.0
                                     target:self
                                   selector:@selector(wallpaperTimer)
                                   userInfo:nil
                                    repeats:YES];
    
}




//seems to work, as long as no concurrency issues
-(void) deleteFile:(NSString *) imgName
{
    NSString * documentsDirectoryPath = [self getImagePaths];
    NSError * error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
   
    NSString *writablePath = [documentsDirectoryPath stringByAppendingPathComponent:imgName];
    
    BOOL result  = [fileManager removeItemAtPath:writablePath error:&error];
    //NSLog([NSString stringWithFormat:@"@" ]);
    NSLog(result ? @"Yes removed file" : @"No, did not remove file");
    if(error)
    {
        NSLog(@"there was an error removing file:%@", error);
    }
}

//This should handle updating the lists and grabbing new images
-(void) refreshList
{
    //Delete old images
    for(NSString * imageName in toBeDeleted)
    {
        [self deleteFile:imageName];
        
    }
    //empty deletion pile
    [toBeDeleted removeAllObjects];
    
    //needs to have access to config data
    //for each subreddit on the list
    //needs to pull from reddit
    
    //needs to save those images to disk
    
    //Make the reddit calls to buld up list of images
    //Need to expand to multiple subreddits
    for(NSString * subreddit in subreddits)
    {
    [self callReddit:subreddit];
    }
    //once have the list of images
    for(NSString * curString in urlList)
    {
        //split out the unique imgur tag
        NSArray *array = [curString componentsSeparatedByString:@"/"];
        NSString * split = array[3];
        array = [split componentsSeparatedByString:@"."];
        split = array[0];
        
        //create a key value mapping with the url as the key and the imagename as value
        NSMutableString * imageName = [NSMutableString stringWithFormat:@"%@", split];
        [imageName appendFormat:@".png"];
        
        [finalUrlList setObject:imageName forKey:curString];
        //Save all of the local images
        [self saveImageInLocalDirectory:curString filename: imageName ];
    }
    
}
-(void)wallpaperTimer
{
    NSURL * curImagePath;
    NSString * curKey;
    NSString * curValue;
    //grab a local image url
    //NSLog(@"in wallpapper timer, just before if index");
    if(finalUrlList != nil)
    {
        //If there are <4 then pull new images
        if (finalUrlList.count < 4)
        {
            //pull from subreddits
            NSLog(@"pulling new images");
            [self refreshList];
        }
        //Then, providing there are more then 0. set a wallpaper
        if (finalUrlList.count > 0)
        {
            //This is completely randomized, so images can be in any order
            curValue = finalUrlList[[[finalUrlList allKeys] objectAtIndex:0]];
            //NSLog(@"index 0 is: %@", finalUrlList[[[finalUrlList allKeys] objectAtIndex:0]]);
            
            NSArray *temp = [finalUrlList allKeysForObject:curValue];
            curKey = [temp lastObject];
            
            curValue = [finalUrlList objectForKey:curKey];
            curImagePath = [self getFileUrl:curValue];
            //Set the wallpaper
            [self setWallpaper: curImagePath];
            
            //add the "used" wallpaper for deletion
            [toBeDeleted addObject:curValue];
            //[self deleteFile:curValue];
            
            //Remove the item from the up next list
            [finalUrlList removeObjectForKey:curKey];
            
        }
    }
    
}


-(void)setWallpaper:(NSURL *) imageUrl
{
    NSArray *screens = [NSScreen screens];
    NSScreen *curScreen;
    for (curScreen in screens)
    {
        NSError *error = nil;
        // get the current screen options
        NSMutableDictionary *screenOptions =
        
        [[[NSWorkspace sharedWorkspace] desktopImageOptionsForScreen:curScreen] mutableCopy];
        
        //Use reddit url
        NSLog(@"inside set wallpaper image url is:%@", imageUrl);
        
        ///using this still works to set random for testing
        //imageUrl = [self giveRandomImage];
        
        if (![[NSWorkspace sharedWorkspace] setDesktopImageURL:imageUrl
                                                     forScreen:curScreen
                                                       options:screenOptions
                                                         error:&error])
        {
            //Give an error message/ try dif background?
            if(error)
            {
                NSLog(@"there was an error:%@", error);
            }
            //[self presentError:error];
        }
        
    }
}

//Used to test background setting using a local image
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

- (IBAction)changePicture:(id)sender
{
    [self wallpaperTimer];
}

- (IBAction)changeSubreddits:(id)sender
{
    NSLog(@"changing subreddits");
    //[self setWallpaper];
    
    /*ViewControllerMonitorMenu *monitorMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerMonitorMenu"];
     [self presentViewController:monitorMenuViewController animated:NO completion:nil];
     */
    
    
    /*OptionsWindowController *add = [[OptionsWindowController alloc]
                                    initWithWindowNibName:@"OptionsWindow"];
    [add showWindow:add];*/
    
    
    self.thing = [[OptionsWindowController alloc]
                                    initWithWindowNibName:@"OptionsWindowController"];
    [self.thing showWindow:self.thing];
    //[self.thing makeKeyAndOrderFront:self.thing];
    
    
    
    
    //[window makeKeyAndOrderFront:add];
    
    //UIViewController *vc = self.window.rootViewController;
    //vc.
    /*SettingsViewController * test = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
    [test loadView];*/
    
    //[self ]

    //[NSApplication presentViewController:OptionsWindowcontroller animated:YES ^{}];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
   // self.window = [[NSWindow alloc] initWithFrame:[[NSScreen mainScreen] ]];
   // self.window.contentViewController = [[SettingsViewController alloc] init];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    
    //write out preferences to config file
}

//Grabs a number in the range given
-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

//Saves a remote url to a file into the docs folder
-(void)saveImageInLocalDirectory:(NSString*)url filename:(NSString *) fileName
{
    NSString * documentsDirectoryPath = [self getImagePaths];
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

//Call the reddit api and get a set of images
-(void)callReddit:(NSString *) subreddit
{
//just give your URL instead of my URL
//http://www.reddit.com/r/ + subreddit + /hot.json
    NSString * reddit = @"http://www.reddit.com/r/";
    reddit = [reddit stringByAppendingString:subreddit];
    NSString * finalPath = [reddit stringByAppendingString:@"/hot.json"];
    
NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL  URLWithString:finalPath]];

[request setHTTPMethod:@"GET"];

[request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
[request setValue:@"BackgroundSwitcher Agent" forHTTPHeaderField:@"User-Agent"];
NSError *err;

NSURLResponse *response;

NSData *responseData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&response error:&err];

NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options: NSJSONReadingMutableContainers error: &err];

    //NSLog(jsonArray);
    
    NSArray *array=[[jsonArray objectForKey:@"data"]objectForKey:@"children"];
    //start parsing it down
    //each element of the array is a post
    for (NSDictionary * groupDic in array) {
        NSDictionary *dict = [groupDic objectForKey:@"data"];
        NSString * url = [dict objectForKey:@"url"];
        
        //if the url has a jpg or png ext then add
        //should revise to better method
        if(([url rangeOfString:@"jpg"].location != NSNotFound) || ([url rangeOfString:@"png"].location != NSNotFound) ) {
            
            [urlList addObject:url];
            
        }
        
    }
    
    
}

-(void) makeFolder{
    NSString * imageDirPath = [self getImagePaths];
    NSError * error = nil;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath: imageDirPath
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:&error];
    if (!success)
        NSLog(@"Error creating folder");
    else
        NSLog(@"Successfully created folder");
}

-(NSString * ) getImagePaths
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString * imageDir = @"/backgroundimages";
    NSString *imageDirPath = [documentsDirectory stringByAppendingPathComponent:imageDir];
    
    return imageDirPath;
}



-(NSURL*) getFileUrl:(NSString *) fileName
{
    //get the image path, append filename and get url
    NSString *yourSoundPath = [[self getImagePaths] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:yourSoundPath])
    {
        NSURL *soundURL = [NSURL fileURLWithPath:yourSoundPath isDirectory:NO];
        return soundURL;
    }
    
    return nil;
}


@end
