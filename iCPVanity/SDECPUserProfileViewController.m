//
//  SDEUserProfileViewController.m
//  iCPVanity
//
//  Created by serge desmedt on 3/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECPUserProfileViewController.h"
#import "SDECPUserArticlesViewController.h"

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
    
    // 122954 - with image
    // 15715 - mine
    _MemberIdTextField.text = @"15715";
    
    activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake (120.0, 185.0, 80, 80)];
    activityView.color = [UIColor darkGrayColor];
    
    [self.view addSubview:activityView];

}

- (IBAction) fillWithMember {
    
    [_MemberIdTextField resignFirstResponder];
    NSString* memberIdAsString = _MemberIdTextField.text;
    NSInteger memberId = [memberIdAsString integerValue];
    codeprojectMember = [[SDECodeProjectMember alloc] initWithId:memberId delegate:self];
    
    [activityView startAnimating];
    
}

- (void) codeprojectMemberAvailable {
    
    [activityView stopAnimating];
    
    self.NameLabel.text = codeprojectMember.MemberName;
    self.ReputationLabel.text = codeprojectMember.Reputation;
    
    self.AvgArticleRatingLabel.text = [NSString stringWithFormat:@"Average articles rating: %@", codeprojectMember.AvgArticleRating];
    self.ArticleCountLabel.text = [NSString stringWithFormat:@"%d articles available", codeprojectMember.ArticleList.count];
    
    self.AvgBlogRatingLabel.text = [NSString stringWithFormat:@"Average blog rating: %@", codeprojectMember.AvgBlogRating];
    self.BlogCountLabel.text = [NSString stringWithFormat:@"%d blogposts available", codeprojectMember.BlogList.count];
    
    NSString* imagUrl = [codeprojectMember.ImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagUrl]]];
    [self.MemberImage setImage:image];
    
}


- (void)codeprojectMemberProfileAvailable {

}


- (void)codeprojectMemberArticleAvailable {

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MemberArticlesSegue"]) {
        
        SDECPUserArticlesViewController *memberArticlesViewController = (SDECPUserArticlesViewController*)segue.destinationViewController;
        memberArticlesViewController.CodeprojectMember = codeprojectMember;
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
