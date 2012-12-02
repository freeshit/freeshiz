//
//  FZAppDelegate.m
//  freeshiz
//
//  Created by Zac Bowling on 12/1/12.
//  Copyright (c) 2012 freeshiz. All rights reserved.
//

#import "FZAppDelegate.h"
#import "FZSearchTabController.h"
#import <SinglySDK/SinglySDK.h>

#define CLIENT_ID @"1deac17a596c4c5db6d9c4c156609d6f"
#define CLIENT_SECRET @"1deac17a596c4c5db6d9c4c156609d6f"


NSString *const FZServerURLPrefix = @"http://freeshit.herokuapp.com/";

@interface FZAppDelegate()<CLLocationManagerDelegate>

@property (nonatomic,strong) FZSearchTabController *rootViewController;
@property (nonatomic,strong) CLLocationManager *locationManager;
@end

@implementation FZAppDelegate
@synthesize rootViewController = _rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0 green:100.0f/255.0f blue:0 alpha:1.0f]];

  SinglySession *session = [SinglySession sharedSession];
  session.clientID = CLIENT_ID;
  session.clientSecret = CLIENT_SECRET;

  [session startSessionWithCompletionHandler:^(BOOL ready) {
    if (ready) {
        // The session is ready to go!
    } else {
        // You will need to auth with a service...
    }
  }];
	
	_rootViewController = [[FZSearchTabController alloc] initWithNibName:nil bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
	self.window.rootViewController = _rootViewController;
	
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
	self.locationManager.distanceFilter = 10; // or whatever
    [self.window makeKeyAndVisible];
	[self.locationManager startUpdatingLocation];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	self.currentLocation = [locations lastObject];
}

@end
