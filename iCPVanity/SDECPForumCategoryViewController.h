//
//  SDECPForumCategoryViewController.h
//  iCPVanity
//
//  Created by serge desmedt on 16/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDECPRssViewController.h"

@interface SDECPForumCategoryViewController : UITableViewController

@property (nonatomic, assign) id<SDECPRssFeedSelection> categorySelectionDelegate;

@end
