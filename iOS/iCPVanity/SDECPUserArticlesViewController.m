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

@interface SDECPUserArticlesViewController ()

@end

@implementation SDECPUserArticlesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.ArticleView.dataSource = self;
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

        //pageViewController.Url = ((SDECodeProjectArticle*)[self.CodeprojectMember.ArticleList objectAtIndex:indexPath.row]).Link;
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
    return 0; //self.CodeprojectMember.ArticleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArticleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    SDECodeProjectArticle *article = NULL; //[self.CodeprojectMember.ArticleList objectAtIndex:indexPath.row];

    ((UILabel*)[cell viewWithTag:100]).text = article.Title;
    ((UILabel*)[cell viewWithTag:101]).text = article.DateUpdated;
    ((UILabel*)[cell viewWithTag:102]).text = article.Rating;
    ((UILabel*)[cell viewWithTag:103]).text = [NSString stringWithFormat:@"(%@ votes)", article.Votes];
    
    return cell;
}

@end
