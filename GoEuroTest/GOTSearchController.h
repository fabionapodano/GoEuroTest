//
//  GOTFirstViewController.h
//  GoEuroTest
//
//  Created by Fabio Napodano on 07/11/13.
//  Copyright (c) 2013 Fabio Napodano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GOTPlace;

@interface GOTSearchController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate>
{

    UITableView *tvStartLocations, *tvEndLocations;
    NSArray *arrStartLocations, *arrEndLocations;
    
    UITextField *txtStartLocation, *txtEndLocation, *txtDate;
    
    UIDatePicker *dpDate;
    
    BOOL bIsEditingStartLocation, bIsEditingEndLocation;
    
    NSURLConnection *connLocations;
    NSMutableData *dataJSON;
    
    GOTPlace *placeStart, *placeEnd;
    
}
@end
