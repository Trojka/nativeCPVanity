//
//  SDECPArticleCatgoryViewController.h
//  iCPVanity
//
//  Created by serge desmedt on 11/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDECPRssViewController.h"

@interface SDECPArticleCategoryViewController : UITableViewController

@property (nonatomic, assign) id<SDECPRssFeedSelection> categorySelectionDelegate;

@end
