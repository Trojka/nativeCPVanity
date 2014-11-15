//
//  SDECPRssViewController.h
//  iCPVanity
//
//  Created by serge desmedt on 16/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDERSSFeed.h"
#import "SDECodeProjectFeed.h"

@protocol SDECPRssFeedSelection <NSObject>

- (void) selectedFeed:(SDECodeProjectFeed*) feed;

@end

@interface SDECPRssViewController : UIViewController<SDECPRssFeedSelection, SDERSSFeedDelegate, UITableViewDataSource, UITableViewDelegate>

- (void) loadRSS;

//- (void) feedLoaded;

//- (void) selectedFeed:(SDECodeProjectFeed*) feed;

- (NSString*) entryCellIdentifier;

@property (nonatomic) SDECodeProjectFeed* Feed;

@property (nonatomic) NSMutableArray* Entries;

@property (strong, nonatomic) IBOutlet UITableView *EntriesView;

@property (strong, nonatomic) IBOutlet UILabel *FeedLabel;

@end