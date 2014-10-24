//
//  SDECPUserArticlesViewController.h
//  iCPVanity
//
//  Created by serge desmedt on 3/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDEUserDataViewController.h"
#import "SDECodeProjectMember.h"

@interface SDECPUserArticlesViewController : UIViewController<UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *ArticleView;

@property (nonatomic, readwrite) SDECodeProjectMember* CodeprojectMember;

@end
