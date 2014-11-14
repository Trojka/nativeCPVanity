//
//  SDEUserProfileViewController.m
//  iCPVanity
//
//  Created by serge desmedt on 3/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECPUserProfileViewController.h"
#import "SDECPUserArticlesViewController.h"
#import "SDECodeProjectMemberStore.h"

@implementation SDECPUserProfileViewController

UIActivityIndicatorView *activityView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.NameLabel.text = @"";
    self.ReputationLabel.text = @"";
    self.AvgArticleRatingLabel.text = @"Average articles rating:";
    self.ArticleCountLabel.text = @"0 articles available";
    self.AvgBlogRatingLabel.text = @"Average blog rating:";
    self.BlogCountLabel.text = @"0 blogposts available";
    
    activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake (120.0, 185.0, 80, 80)];
    activityView.color = [UIColor darkGrayColor];
    
    [self.view addSubview:activityView];
    
    [self fillWithMemberWithId:self.CodeprojectMemberId];

}

- (IBAction) saveMember {
    SDECodeProjectMemberStore* memberStore = [[SDECodeProjectMemberStore alloc] init];
    
    [memberStore saveMember:self.CodeprojectMember];
}

- (void) fillWithMemberWithId:(NSInteger)memberId {
    self.CodeprojectMember = [[SDECodeProjectMember alloc] initWithId:memberId];
    
    SDECodeProjectWeb* cpWeb = [[SDECodeProjectWeb alloc]init];
    [cpWeb fillMember:self.CodeprojectMember delegate:self];
    
    [activityView startAnimating];
    
}

- (void) codeprojectMemberAvailable {
    
    [activityView stopAnimating];
    
    self.NameLabel.text = self.CodeprojectMember.MemberName;
    self.ReputationLabel.text = self.CodeprojectMember.Reputation;
    
    self.AvgArticleRatingLabel.text = [NSString stringWithFormat:@"Average articles rating: %@", self.CodeprojectMember.AvgArticleRating];
    self.ArticleCountLabel.text = [NSString stringWithFormat:@"%d articles available", self.CodeprojectMember.ArticleCount];
    
    self.AvgBlogRatingLabel.text = [NSString stringWithFormat:@"Average blog rating: %@", self.CodeprojectMember.AvgBlogRating];
    self.BlogCountLabel.text = [NSString stringWithFormat:@"%d blogposts available", self.CodeprojectMember.BlogCount];
    
    if (self.CodeprojectMember.Gravatar == NULL) {
        
        UIImage* gravatar = [SDECodeProjectMemberStore getMemberGravatar:self.CodeprojectMember];
        if (gravatar == NULL) {
            NSString* imagUrl = [self.CodeprojectMember.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagUrl]]];
            
            self.CodeprojectMember.Gravatar = image;
        }

    }
    [self.MemberImage setImage:self.CodeprojectMember.Gravatar];
    
}


- (void)codeprojectMemberProfileAvailable {

}


- (void)codeprojectMemberArticleAvailable {

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MemberArticlesSegue"]) {
        
        SDECPUserArticlesViewController *memberArticlesViewController = (SDECPUserArticlesViewController*)segue.destinationViewController;
        memberArticlesViewController.CodeprojectMember = self.CodeprojectMember;
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
