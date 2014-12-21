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
    NSMutableDictionary * finalUrlList;
    
}

@end

@implementation AppDelegate

@synthesize window;

- (void) awakeFromNib{
    //data
    urlList = [NSMutableArray new];
    finalUrlList = [NSMutableDictionary new];
    //Load up from config files
    
    
    
    //statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength]]
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSBundle * bundle = [NSBundle mainBundle ];
    
    statusImage = [[NSImage alloc ] initWithContentsOfFile:[bundle pathForResource:@"picture11" ofType:@"png"]];
    
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
        //split out the unique imgur tag
        NSArray *array = [curString componentsSeparatedByString:@"/"];
        NSString * split = array[3];
        array = [split componentsSeparatedByString:@"."];
        split = array[0];
        
        //NSLog(array[3]);
        //create a key value mapping with the url as the key and the imagename as value
        NSMutableString * imageName = [NSMutableString stringWithFormat:@"%@", split];
        [imageName appendFormat:@".png"];
        
        //[finalUrlList setObject:imageName forKey:curString];
        [finalUrlList setObject:imageName forKey:curString];
        //Save all of the local images
        [self saveImageInLocalDirectory:curString filename: imageName ];
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
                                   selector:@selector(wallpaperTimer)
                                   userInfo:nil
                                    repeats:YES];
    
}
- (IBAction)doSomething:(id)sender
{
    NSLog(@"is doing something");
    
    [self setWallpaper];
}

-(NSURL*) getFileUrl:(NSString *) fileName
{
    //NSString *filename = @"whatever you've saved your filename as";
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    NSString *yourSoundPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:yourSoundPath])
    {
        NSURL *soundURL = [NSURL fileURLWithPath:yourSoundPath isDirectory:NO];
        return soundURL;
    }
    
    return nil;
}

-(void) deleteFile:(NSString *) imgName
{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
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

-(void)wallpaperTimer
{
    NSString * curImageName;
    NSURL * curImagePath;
    NSString * curKey;
    NSString * curValue;
    //grab a local image url
     NSLog(@"in wallpapper timer, just before if index");
    if(finalUrlList != nil)
    {
        if ([finalUrlList allKeys] > 0)
        {
            /*NSArray *temp = [dict allKeysForObject:knownObject];
             NSString *key = [temp lastObject];*/
            //curKey = finalUrlList[[[finalUrlList allKeys] objectAtIndex:0]];
            NSLog(@"test count %d", finalUrlList.count);
            //testing
            curValue = finalUrlList[[[finalUrlList allKeys] objectAtIndex:[self getRandomNumberBetween:1 to:finalUrlList.count -1]]];
            //curValue = finalUrlList[[[finalUrlList allKeys] objectAtIndex:0]];
            NSLog(@"index 0 is: %@", finalUrlList[[[finalUrlList allKeys] objectAtIndex:0]]);
            
            NSArray *temp = [finalUrlList allKeysForObject:curValue];
            curKey = [temp lastObject];
            
            curValue = [finalUrlList objectForKey:curKey];
            //curValue = [finalUrlList objectforVal:curKey];
            //curImagePath [NSurl fileU  documentsDirectory]
            //NSString * test = NSDocumentDirectory;
            curImagePath = [self getFileUrl:curValue];
            //If it is nill, try a new image
            //NSString * fixedImage = @"ASKTsUz.png";
            //NSURL * tempPath = [self getFileUrl:fixedImage];
            //[self setWallpaper:tempPath];
            
            NSLog(@"before setting, path is:%@", curImagePath);
            [self setWallpaper: curImagePath];
            
            //remove the current used wallpaper
            //[self deleteFile:curValue];
            
            //[finalUrlList removeObjectForKey:curKey];
            
        }
    }
    
}


-(void)setWallpaper:(NSURL *) imageUrl
{
    NSLog(@"inside set wallpaper");
    //NSImage * backImage;
    //NSBundle * bundle = [NSBundle mainBundle ];
    
    //backImage = [[NSImage alloc ] initWithContentsOfFile:[bundle pathForResource:@"back1" ofType:@"jpg"]];
    
    NSArray *screens = [NSScreen screens];
    NSScreen *curScreen;
    NSUInteger screenIndex = 1;
    for (curScreen in screens)
    {
        NSError *error = nil;
        // get the current screen options
        NSMutableDictionary *screenOptions =
        
        [[[NSWorkspace sharedWorkspace] desktopImageOptionsForScreen:curScreen] mutableCopy];
       
        
        //NSURL *imageURL = [[NSWorkspace sharedWorkspace] desktopImageURLForScreen:curScreen];
        
        //Use reddit url
        NSLog(@"inside set wallpaper image url is:%@", imageUrl);
        
        ///using this still works to set
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
    
    //write out preferences to config file
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
            //testing
            //add i. to beginning to make sure it is an image.
            //NSString * test = @"i.";
            //test += url;
            //test = [test stringByAppendingString:url];
            //Add the url to the global list
            [urlList addObject:url];
            //[urlList addObject:test];
            //[finalUrlList insertValue:url inPropertyWithKey:@"1234"];
            //[finalUrlList setObject:url forKey:url];
            NSLog(@"string contains bla!");
        }
        
    }
    
    
}


@end
