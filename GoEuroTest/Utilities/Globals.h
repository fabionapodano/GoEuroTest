//
//  Globals.h
//  GoEuroTest
//
//  Created by Fabio Napodano on 07/11/13.
//  Copyright (c) 2013 Fabio Napodano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject

+ (CGFloat) getFontSizeTitle;
+ (CGFloat) getFontSizeText;
+ (UIColor*) getTextColor;

+ (BOOL) dateToLocalizedString:(NSString**)sDestination dSource:(NSDate*)dSource;

+ (void) showWarning:(NSString *)sTitle sMessage:(NSString*)sMessage;

+ (NSString*) getAppName;
@end
