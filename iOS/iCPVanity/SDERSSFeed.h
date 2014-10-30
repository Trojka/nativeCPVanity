//
//  SDERSSFeed.h
//  iCPVanity
//
//  Created by serge desmedt on 9/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDERSSFeedDelegate <NSObject>

- (void) feedLoaded;

@end


@interface SDERSSFeed : NSObject<NSXMLParserDelegate>

- (id) initWithContentsOfURL: (NSURL*) feedUrl;

- (void) loadRSS;

@property (nonatomic, readwrite) id<SDERSSFeedDelegate> delegate;

@property (nonatomic, readwrite) NSArray* Items;

@end
