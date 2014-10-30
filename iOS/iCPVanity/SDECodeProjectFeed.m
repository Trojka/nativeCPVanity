//
//  SDECodeProjectFeed.m
//  iCPVanity
//
//  Created by serge desmedt on 14/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECodeProjectFeed.h"

@implementation SDECodeProjectFeed

-(id)initWithName:(NSString*)name AndUrl:(NSString*)url
{
    self = [super init];
    if (self) {
        
        self.Name = name;
        
        self.Url = url;
    }
    return self;
}

@end
