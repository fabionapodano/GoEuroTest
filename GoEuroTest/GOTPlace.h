//
//  GOTPlace.h
//  GoEuroTest
//
//  Created by Fabio Napodano on 07/11/13.
//  Copyright (c) 2013 Fabio Napodano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GOTPlace : NSObject

- (id) initWithName:(NSString*)sName andLocation:(CLLocation*)locLocation;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) CLLocation *location;

@end
