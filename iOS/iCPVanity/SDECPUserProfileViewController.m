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

//- (NSManagedObjectContext *)managedObjectContext {
//    NSManagedObjectContext *context = nil;
//    id delegate = [[UIApplication sharedApplication] delegate];
//    if ([delegate performSelector:@selector(managedObjectContext)]) {
//        context = [delegate managedObjectContext];
//    }
//    return context;
//}

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
    
    [self fillWithMemberWithId:self.CodeprojectMemberId];

}

- (IBAction) fillWithMember {
    
    [_MemberIdTextField resignFirstResponder];
    NSString* memberIdAsString = _MemberIdTextField.text;
    NSInteger memberId = [memberIdAsString integerValue];

    [self fillWithMemberWithId:memberId];
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
    self.ArticleCountLabel.text = [NSString stringWithFormat:@"%d articles available", self.CodeprojectMember.ArticleList.count];
    
    self.AvgBlogRatingLabel.text = [NSString stringWithFormat:@"Average blog rating: %@", self.CodeprojectMember.AvgBlogRating];
    self.BlogCountLabel.text = [NSString stringWithFormat:@"%d blogposts available", self.CodeprojectMember.BlogList.count];
    
    NSString* imagUrl = [self.CodeprojectMember.ImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
        memberArticlesViewController.CodeprojectMember = self.CodeprojectMember;
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
