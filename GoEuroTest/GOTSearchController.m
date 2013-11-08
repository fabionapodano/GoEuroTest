//
//  GOTFirstViewController.m
//  GoEuroTest
//
//  Created by Fabio Napodano on 07/11/13.
//  Copyright (c) 2013 Fabio Napodano. All rights reserved.
//

#import "GOTSearchController.h"
#import "GOTPlace.h"

#import "SBJsonParser.h"

static const NSUInteger kTAG_TV_STARTLOCATION = 10000, kTAG_TV_ENDLOCATION = 10001;
static const NSUInteger kTAG_TE_STARTLOCATION = 20000, kTAG_TE_ENDLOCATION = 20001, kTAG_TE_DATE = 20002;
static const NSUInteger kTAG_DP_DATE = 30000;
static const NSUInteger kTAG_BTN_SEARCH = 40000;

@interface GOTSearchController ()

@end

@implementation GOTSearchController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    CGFloat nWidth = [UIDevice getScreenWidth];
    CGFloat nLeft = nWidth*.1f;
    nWidth -= 2*nLeft;
    CGFloat nTop = [UIDevice getScreenHeight]*.03f + ([UIDevice getOSVersion] >= 7.0f? self.navigationController.tabBarController.tabBar.frame.size.height:0);
    CGFloat nFontSize = [Globals getFontSizeText];

    txtStartLocation = [[UITextField alloc] initWithFrame:CGRectMake(nLeft, nTop, nWidth, nFontSize*1.2f)];
    [txtStartLocation setTag:kTAG_TE_STARTLOCATION];
    [txtStartLocation setDelegate:self];
    [txtStartLocation setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txtStartLocation setBackgroundColor:[UIColor colorWithWhite:.8f alpha:.5f]];
    [txtStartLocation setFont:[UIFont systemFontOfSize:[Globals getFontSizeText]]];
    [txtStartLocation setTextColor:[Globals getTextColor]];
    [txtStartLocation setPlaceholder:NSLocalizedString(@"Start location", @"")];
    [txtStartLocation setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [txtStartLocation addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    nTop += txtStartLocation.frame.size.height;

    tvStartLocations = [[UITableView alloc] initWithFrame:CGRectMake(nLeft, nTop, nWidth, txtStartLocation.frame.size.height*3.9f)];
    [tvStartLocations setTag:kTAG_TV_STARTLOCATION];
    [tvStartLocations setAllowsMultipleSelection:NO];
    [tvStartLocations setDelegate:self];
    [tvStartLocations setDataSource:self];
    [tvStartLocations setBackgroundColor:[UIColor whiteColor]];

    nTop += nFontSize;
    
    txtEndLocation = [[UITextField alloc] initWithFrame:CGRectMake(nLeft, nTop, nWidth, nFontSize*1.2f)];
    [txtEndLocation setTag:kTAG_TE_ENDLOCATION];
    [txtEndLocation setDelegate:self];
    [txtEndLocation setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txtEndLocation setBackgroundColor:[UIColor colorWithWhite:.8f alpha:.5f]];
    [txtEndLocation setFont:[UIFont systemFontOfSize:[Globals getFontSizeText]]];
    [txtEndLocation setTextColor:[Globals getTextColor]];
    [txtEndLocation setPlaceholder:NSLocalizedString(@"End location", @"")];
    [txtEndLocation setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [txtEndLocation addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    nTop += txtEndLocation.frame.size.height;
    
    tvEndLocations = [[UITableView alloc] initWithFrame:CGRectMake(nLeft, nTop, nWidth, txtEndLocation.frame.size.height*3.9f)];
    [tvEndLocations setTag:kTAG_TV_ENDLOCATION];
    [tvEndLocations setAllowsMultipleSelection:NO];
    [tvEndLocations setDelegate:self];
    [tvEndLocations setDataSource:self];
    [tvEndLocations setBackgroundColor:[UIColor whiteColor]];
    
    nTop += nFontSize;
    txtDate = [[UITextField alloc] initWithFrame:CGRectMake(nLeft, nTop, nWidth, nFontSize*1.2f)];
    [txtDate setTag:kTAG_TE_DATE];
    [txtDate setDelegate:self];
    [txtDate setBackgroundColor:[UIColor colorWithWhite:.8f alpha:.5f]];
    [txtDate setFont:[UIFont systemFontOfSize:[Globals getFontSizeText]]];
    [txtDate setTextColor:[Globals getTextColor]];
    [txtDate setPlaceholder:NSLocalizedString(@"Choose a date", @"")];
    
    dpDate = [[UIDatePicker alloc] initWithFrame:CGRectMake(nLeft, nTop, nWidth, 0)];
    [dpDate setTag:kTAG_DP_DATE];
    [dpDate setMinimumDate:[NSDate date]];
    [dpDate setDate:[NSDate date]];
    [dpDate setDatePickerMode:UIDatePickerModeDate];
    [dpDate addTarget:self action:@selector(date_changed:) forControlEvents:UIControlEventValueChanged];
    
    [txtDate setInputView:dpDate];
    
    nTop += txtDate.frame.size.height;
    nTop += nFontSize;
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnSearch setFrame:CGRectMake(nLeft, nTop, nWidth, txtEndLocation.frame.size.height*1.3f)];
    [btnSearch setTag:kTAG_BTN_SEARCH];
    [btnSearch setTitleColor:[Globals getTextColor] forState:UIControlStateNormal];
    [btnSearch setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnSearch setTitle:NSLocalizedString(@"Search", @"") forState:UIControlStateNormal];
    [btnSearch setTitle:NSLocalizedString(@"Searching...", @"") forState:UIControlStateHighlighted];
    [btnSearch addTarget:self action:@selector(btnSearch_tapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:txtStartLocation];
    [self.view addSubview:txtEndLocation];
    [self.view addSubview:txtDate];
    [self.view addSubview:btnSearch];
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognize];
    
    
    [self.view setUserInteractionEnabled:YES];
    
}

- (void) startWait
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
}

- (void) stopWait
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
}

#pragma mark label UITextField Delegate methods

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    [textField setText:@""];

    switch (textField.tag) {
        case kTAG_TE_STARTLOCATION:
            
            bIsEditingStartLocation = YES;
            bIsEditingEndLocation = NO;
            [tvStartLocations removeFromSuperview];
            [dpDate removeFromSuperview];
            
            break;
            
        case kTAG_TE_ENDLOCATION:
            
            bIsEditingStartLocation = NO;
            bIsEditingEndLocation = YES;
            [tvStartLocations removeFromSuperview];
            [dpDate removeFromSuperview];
            
            break;
            
        default:

            bIsEditingStartLocation = NO;
            bIsEditingEndLocation = NO;

            break;
    }

}

- (void) textFieldDidChange:(UITextField*)textField
{

    NSString *sSearchText = textField.text;
    
    if (sSearchText && ![sSearchText isEqualToString:@""]) {

        NSURL *urlLocations = [NSURL URLWithString:[[NSString stringWithFormat:@"http://pre.dev.goeuro.de:12345/api/v1/suggest/position/en/name/%@",sSearchText] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *reqLocatons = [NSURLRequest requestWithURL:urlLocations cachePolicy:NSURLCacheStorageAllowed timeoutInterval:20];
        
        [connLocations cancel];
        connLocations = [[NSURLConnection alloc] initWithRequest:reqLocatons delegate:self startImmediately:YES];
        [self startWait];

    } else
    {
        [tvStartLocations removeFromSuperview];
        [tvEndLocations removeFromSuperview];
    }
    
    switch (textField.tag) {
        case kTAG_TE_STARTLOCATION:
            
            bIsEditingStartLocation = YES;
            bIsEditingEndLocation = NO;
            
            break;
            
        case kTAG_TE_ENDLOCATION:
            
            bIsEditingStartLocation = NO;
            bIsEditingEndLocation = YES;
            
            break;
            
        default:
            break;
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -

#pragma mark label NSURLConnection Delegate methods


- (void)connection:(NSURLConnection *)connectionResponse didReceiveResponse:(NSHTTPURLResponse *)response
{
    
    NSUInteger nHTTPStatusCode = ((NSHTTPURLResponse*)response).statusCode;

    if (nHTTPStatusCode >= 400) {

        dataJSON = nil;
        [connectionResponse cancel];
        
        [self connection:connectionResponse didFailWithError:[NSError errorWithDomain:[response.URL absoluteString] code:nHTTPStatusCode userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Got HTTP error %d while trying to load data from URL %@",nHTTPStatusCode,response.URL] forKey:@"description"]]];
        
    } else
    {
        
        NSUInteger nExpectedDataSize = (NSUInteger)response.expectedContentLength;
        
        if(nExpectedDataSize>0)
            dataJSON = [NSMutableData dataWithCapacity:nExpectedDataSize];

    }
    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection cancel];
    [Globals showWarning:[Globals getAppName] sMessage:NSLocalizedString(@"Connection error, please check your Internet connection", @"")];
    NSLog(@"Error: %@",error);
    
    [self stopWait];
    
}

- (void) connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData
{
	if (dataJSON==nil) { dataJSON = [[NSMutableData alloc] initWithCapacity:2048]; }
	[dataJSON appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    
	connLocations = nil;
    
    [self stopWait];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dictLocations = [parser objectWithData:dataJSON];
    
    if (dictLocations) {
        
        NSArray *arrResults = [dictLocations objectForKey:@"results"];
        NSMutableArray *arrSortedResults = nil;
        
        if ([arrResults count]) {

            arrSortedResults = [NSMutableArray arrayWithCapacity:[arrResults count]];
            
            for (NSDictionary *dictResult in arrResults) {
                
                NSDictionary *dictPosition = [dictResult objectForKey:@"geo_position"];
                
                float fLatitude = [((NSNumber*)[dictPosition objectForKey:@"latitude"]) floatValue];
                float fLongitude = [((NSNumber*)[dictPosition objectForKey:@"longitude"]) floatValue];
                
                CLLocation *locPlace = [[CLLocation alloc] initWithLatitude:fLatitude longitude:fLongitude];
                
                GOTPlace *place = [[GOTPlace alloc] initWithName:[dictResult objectForKey:@"name"] andLocation:locPlace];
                
                [arrSortedResults addObject:place];
                
            }
            
            [arrSortedResults sortUsingComparator:^NSComparisonResult(GOTPlace *obj1, GOTPlace *obj2) {
                
                CLLocation *locCurrent = [GOTAppDelegate getAppDelegate].locationCurrent;
                
                NSNumber *fDist1 = [NSNumber numberWithFloat:[locCurrent distanceFromLocation:obj1.location]];
                NSNumber *fDist2 = [NSNumber numberWithFloat:[locCurrent distanceFromLocation:obj2.location]];
                
                return [fDist1 compare:fDist2];
                
            }];

        } else
        {
            [tvStartLocations removeFromSuperview];
            [tvEndLocations removeFromSuperview];
            return;
        }
        

        
        if (bIsEditingStartLocation)
        {

            arrStartLocations = [NSArray arrayWithArray:arrSortedResults];
            [tvEndLocations removeFromSuperview];
            [tvStartLocations reloadData];
            [self.view addSubview:tvStartLocations];
            
        } else if (bIsEditingEndLocation)
        {

            arrEndLocations = [NSArray arrayWithArray:arrSortedResults];
            [tvStartLocations removeFromSuperview];
            [tvEndLocations reloadData];
            [self.view addSubview:tvEndLocations];
            
        }
        
    } else
    {
        
        if (bIsEditingStartLocation)
            
            arrStartLocations = nil;
        
        else if (bIsEditingEndLocation)
            
            arrEndLocations = nil;
        
    }

    dataJSON = nil;
    
}

#pragma mark -

#pragma mark label UITableView Delegate and Datasource methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (tableView.tag) {
        case kTAG_TV_STARTLOCATION:
            
            return [arrStartLocations count];
            break;

        case kTAG_TV_ENDLOCATION:
            
            return [arrEndLocations count];
            break;

        default:
            return 0;
            break;
    }
    
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *sCellIdentifier = [NSString stringWithFormat:@"Cell%d",tableView.tag];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:[Globals getTextColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:[Globals getFontSizeText]]];
        
    }

    switch (tableView.tag) {
        case kTAG_TV_STARTLOCATION:
            [cell.textLabel setText:((GOTPlace*)[arrStartLocations objectAtIndex:indexPath.row]).name];
            break;
            
        case kTAG_TV_ENDLOCATION:
            [cell.textLabel setText:((GOTPlace*)[arrEndLocations objectAtIndex:indexPath.row]).name];
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITextField *txtField = nil;
    NSString *sPlaceName = nil;
    
    switch (tableView.tag) {
        case kTAG_TV_STARTLOCATION:
            
            placeStart = [arrStartLocations objectAtIndex:indexPath.row];
            txtField = (UITextField*)[self.view viewWithTag:kTAG_TE_STARTLOCATION];
            sPlaceName = placeStart.name;
            
            break;
            
        case kTAG_TV_ENDLOCATION:

            placeEnd = [arrEndLocations objectAtIndex:indexPath.row];
            txtField = (UITextField*)[self.view viewWithTag:kTAG_TE_ENDLOCATION];
            sPlaceName = placeEnd.name;
        
            break;
            
        default:
            break;
    }
    
    [tableView removeFromSuperview];
    [txtField resignFirstResponder];
    [txtField setDelegate:nil];
    [txtField setText:sPlaceName];
    [txtField setDelegate:self];
    
}

#pragma mark -

- (void) btnSearch_tapped:(UIButton*)sender
{
    [Globals showWarning:[Globals getAppName] sMessage:NSLocalizedString(@"Search is not yet implemented", @"")];
}

- (void) date_changed:(UIDatePicker*)sender
{
    NSString *sDate = nil;
    if([Globals dateToLocalizedString:&sDate dSource:sender.date])
        [txtDate setText:sDate];
}

- (void) dismissDatePicker:(id)sender
{
    [txtDate resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
