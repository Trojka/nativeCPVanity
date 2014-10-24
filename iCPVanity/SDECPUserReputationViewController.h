//
//  SDECPUserReputationViewController.h
//  iCPVanity
//
//  Created by serge desmedt on 3/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDEUserDataViewController.h"
#import "SDECodeProjectMember.h"

@interface SDECPUserReputationViewController : UIViewController

@property (nonatomic, readwrite) SDECodeProjectMember* CodeprojectMember;

@property (strong, nonatomic) IBOutlet UIImageView *ReputationGraph;

@end
