//
//  SDECodeProjectArticle.h
//  iCPVanity
//
//  Created by serge desmedt on 29/01/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDECodeProjectArticle : NSObject

@property (nonatomic, readonly) Boolean IsArticle;

@property (nonatomic, readwrite) NSString* Link;

@property (nonatomic, readwrite) NSString* Title;

@property (nonatomic, readwrite) NSString* Description;

@property (nonatomic, readwrite) NSString* DatePosted;

@property (nonatomic, readwrite) NSString* DateUpdated;

@property (nonatomic, readwrite) NSString* Views;

@property (nonatomic, readwrite) NSString* Rating;

@property (nonatomic, readwrite) NSString* Votes;

@property (nonatomic, readwrite) NSString* Popularity;

@property (nonatomic, readwrite) NSString* Bookmarked;

@property (nonatomic, readwrite) NSString* Downloaded;

@end
