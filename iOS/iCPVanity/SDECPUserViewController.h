//
//  SDECPUserViewController.h
//  iCPVanity
//
//  Created by serge desmedt on 25/01/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDECodeProjectMember.h"

//@interface SDECPUserViewController : UIViewController<SDECodeProjectMemberDelegate>
@interface SDECPUserViewController : UIViewController<UIPageViewControllerDataSource, SDECodeProjectMemberDelegate>
{
    SDECodeProjectMember *codeprojectMember;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
