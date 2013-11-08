//
//  UIDevice+Utilities.m
//  GoEuroTest
//
//  Created by Fabio Napodano on 07/11/13.
//  Copyright (c) 2013 Fabio Napodano. All rights reserved.
//

#import "UIDevice+Utilities.h"

@implementation UIDevice (Utilities)


+ (CGFloat) getScreenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat) getScreenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat) getOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}


@end
