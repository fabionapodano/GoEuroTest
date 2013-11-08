//
//  GOTPlace.m
//  GoEuroTest
//
//  Created by Fabio Napodano on 07/11/13.
//  Copyright (c) 2013 Fabio Napodano. All rights reserved.
//

#import "GOTPlace.h"

@implementation GOTPlace

@synthesize name, location;

- (id) initWithName:(NSString*)sName andLocation:(CLLocation*)locLocation
{
    
    self = [super init];
    if (self) {
        
        self.name = sName;
        self.location = locLocation;
    }
    
    return self;
    
}


@end
