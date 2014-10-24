//
//  SDEUserProfileViewController.h
//  iCPVanity
//
//  Created by serge desmedt on 3/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDECodeProjectMember.h"

@interface SDECPUserProfileViewController : UIViewController<SDECodeProjectMemberDelegate>
{
    SDECodeProjectMember *codeprojectMember;
}

- (IBAction) fillWithMember;

@property (strong, nonatomic) IBOutlet UITextField *MemberIdTextField;

@property (strong, nonatomic) IBOutlet UILabel *NameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *MemberImage;

@property (strong, nonatomic) IBOutlet UILabel *ReputationLabel;

@property (strong, nonatomic) IBOutlet UILabel *ArticleCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *AvgArticleRatingLabel;

@property (strong, nonatomic) IBOutlet UILabel *BlogCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *AvgBlogRatingLabel;

@end
