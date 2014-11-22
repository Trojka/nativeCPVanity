//
//  SDEUserListViewController.h
//  iCPVanity
//
//  Created by serge desmedt on 24/10/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDECPUserListViewController : UITableViewController

- (IBAction) refreshMembers;

@property (strong, nonatomic) IBOutlet UITableView *MemberListTableView;

@end
