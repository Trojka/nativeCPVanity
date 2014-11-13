//
//  SDECPUserArticlesViewController.m
//  iCPVanity
//
//  Created by serge desmedt on 3/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECPUserArticlesViewController.h"
#import "SDECPPageViewController.h"
#import "SDECPUserReputationViewController.h"
#import "SDECodeProjectArticle.h"
#import "SDECodeProjectMemberArticles.h"

@interface SDECPUserArticlesViewController ()

@end

@implementation SDECPUserArticlesViewController

UIActivityIndicatorView *activityView;

SDECodeProjectMemberArticles* memberArticles;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake (120.0, 185.0, 80, 80)];
    activityView.color = [UIColor darkGrayColor];
    
    [self.view addSubview:activityView];
    
    [self fillWithArticlesOfMemberWithId:self.CodeprojectMember.MemberId];

}


- (void) fillWithArticlesOfMemberWithId:(NSInteger)memberId {
    
    memberArticles = [[SDECodeProjectMemberArticles alloc]init];
    memberArticles.MemberId = self.CodeprojectMember.MemberId;
    
    SDECodeProjectWeb* cpWeb = [[SDECodeProjectWeb alloc]init];
    [cpWeb fillMemberArticles:memberArticles delegate:self];

    [activityView startAnimating];
    
}

- (void) codeprojectMemberAvailable {
    
}


- (void)codeprojectMemberProfileAvailable {
    
}


- (void)codeprojectMemberArticleAvailable {
    
    [activityView stopAnimating];
    
    self.ArticleView.dataSource = self;
    [self.ArticleView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MemberReputationSegue"]) {
        SDECPUserReputationViewController *memberReputationViewController = (SDECPUserReputationViewController*)segue.destinationViewController;
        
        memberReputationViewController.CodeprojectMember = self.CodeprojectMember;
    }
    else if([segue.identifier isEqualToString:@"MemberArticleSegue"]) {
        SDECPPageViewController *pageViewController = (SDECPPageViewController*)segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.ArticleView indexPathForSelectedRow];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(memberArticles == NULL)
        return 0;
    
    return memberArticles.ArticleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArticleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    SDECodeProjectArticle *article = [memberArticles.ArticleList objectAtIndex:indexPath.row];

    ((UILabel*)[cell viewWithTag:100]).text = article.Title;
    ((UILabel*)[cell viewWithTag:101]).text = article.DateUpdated;
    ((UILabel*)[cell viewWithTag:102]).text = article.Rating;
    ((UILabel*)[cell viewWithTag:103]).text = [NSString stringWithFormat:@"(%@ votes)", article.Votes];
    
    return cell;
}

@end
