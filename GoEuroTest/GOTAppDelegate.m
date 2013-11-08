//
//  GOTAppDelegate.m
//  GoEuroTest
//
//  Created by Fabio Napodano on 07/11/13.
//  Copyright (c) 2013 Fabio Napodano. All rights reserved.
//

#import "GOTAppDelegate.h"
#import "GOTSearchController.h"
#import "GOTSecondViewController.h"

@implementation GOTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self startUpdatingLocation];
    
    _tabBar = [[UITabBarController alloc] init];
    [_tabBar.view setBackgroundColor:[UIColor whiteColor]];
    
    UIViewController *vcSearch = [[GOTSearchController alloc] init];
    [vcSearch setTitle:NSLocalizedString(@"GoEuro", @"")];
    UIViewController *vcOther = [[GOTSecondViewController alloc] init];
    [vcOther setTitle:NSLocalizedString(@"More", @"")];
    
    UINavigationController *navSearch = [[UINavigationController alloc] initWithRootViewController:vcSearch];
    [navSearch setTitle:NSLocalizedString(@"Search", @"")];
    
    [_tabBar setViewControllers:[NSArray arrayWithObjects:navSearch,vcOther,nil]];
    
    [_window setRootViewController:_tabBar];
    [_window makeKeyAndVisible];
    
    
    CGFloat nWaitSize = [UIDevice getScreenWidth]/4.0f;
    _waitingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.window.frame.size.width-nWaitSize)/2, (self.window.frame.size.height-nWaitSize)/2, nWaitSize, nWaitSize)];
    [_waitingView setHidesWhenStopped:YES];
    
    [self.window addSubview:_waitingView];
    
    return YES;
}

+(GOTAppDelegate*) getAppDelegate
{
    return (GOTAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void) startWait
{
    [_waitingView startAnimating];
}

- (void) stopWait
{
    [_waitingView stopAnimating];
}

#pragma mark GeoLocalization methods

- (void) startUpdatingLocation
{
	if(!locationManager) locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
	[self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:150];
}

- (void)stopUpdatingLocation:(NSString *)state
{
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
	NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0)
		return;
	
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0)
		return;
    
	// test the measurement to see if it is more accurate than the previous measurement
    if (self.locationCurrent == nil || self.locationCurrent.horizontalAccuracy > newLocation.horizontalAccuracy)
	{
        // store the location as the "best effort"
        self.locationCurrent = newLocation;
		
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy)
		{
			
            [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"")];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
            
            self.locationCurrent = newLocation;
            
        }
        
    }
    
}


#pragma mark -
							
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

@end
