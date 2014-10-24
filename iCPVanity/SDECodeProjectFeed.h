//
//  SDECodeProjectFeed.h
//  iCPVanity
//
//  Created by serge desmedt on 14/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDECodeProjectFeed : NSObject

-(id)initWithName:(NSString*)name AndUrl:(NSString*)url;

@property (nonatomic, readwrite) NSString* Name;

@property (nonatomic, readwrite) NSString* Url;

@end
