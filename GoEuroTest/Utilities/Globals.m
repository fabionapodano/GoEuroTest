//
//  Globals.m
//  GoEuroTest
//
//  Created by Fabio Napodano on 07/11/13.
//  Copyright (c) 2013 Fabio Napodano. All rights reserved.
//

#import "Globals.h"

@implementation Globals

+ (CGFloat) getFontSizeTitle
{
    return [UIDevice getScreenHeight]/20.0f;
}

+ (CGFloat) getFontSizeText
{
    return [UIDevice getScreenHeight]/25.0f;
}

+ (UIColor*) getTextColor
{
    return [UIColor blackColor];
}

+ (BOOL) dateToLocalizedString:(NSString**)sDestination dSource:(NSDate*)dSource
{
    
    NSString *stringFromDate = [NSDateFormatter localizedStringFromDate:dSource dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
	
	if(stringFromDate)
	{
		*sDestination = [NSString stringWithString:stringFromDate];
		return TRUE;
	} else {
		return FALSE;
	}
}


+ (void) showWarning:(NSString *)sTitle sMessage:(NSString *)sMessage
{
    
	UIAlertView *avError = [
							[UIAlertView alloc]
							initWithTitle:sTitle
							message:sMessage
							delegate:self
							cancelButtonTitle:@"OK"
							otherButtonTitles:nil
							];
	[avError show];
	
}

+ (NSString*) getAppName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}


@end
