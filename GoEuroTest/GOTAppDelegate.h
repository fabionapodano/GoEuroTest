//
//  GOTAppDelegate.h
//  GoEuroTest
//
//  Created by Fabio Napodano on 07/11/13.
//  Copyright (c) 2013 Fabio Napodano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface GOTAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

+ (GOTAppDelegate*) getAppDelegate;
- (void) startWait;
- (void) stopWait;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBar;
@property (strong, nonatomic) UIActivityIndicatorView *waitingView;
@property (strong, nonatomic) CLLocation *locationCurrent;

@end
