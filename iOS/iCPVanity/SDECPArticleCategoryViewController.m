//
//  SDECPArticleCatgoryViewController.m
//  iCPVanity
//
//  Created by serge desmedt on 11/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECPArticleCategoryViewController.h"
#import "SDECodeProjectUrlScheme.h"
#import "SDECodeProjectFeed.h"

@implementation SDECPArticleCategoryViewController

NSArray* articleFeeds;

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableArray* mutableArticleFeeds = [[NSMutableArray alloc] init];
    
    [mutableArticleFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"All Articles" AndUrl:[SDECodeProjectUrlScheme getArticleRSSForCategory:1]]];
    [mutableArticleFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"Android" AndUrl:[SDECodeProjectUrlScheme getArticleRSSForCategory:22]]];
    [mutableArticleFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"Architect" AndUrl:[SDECodeProjectUrlScheme getArticleRSSForCategory:8]]];
    [mutableArticleFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"ASP.NET" AndUrl:[SDECodeProjectUrlScheme getArticleRSSForCategory:4]]];
    [mutableArticleFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"C#" AndUrl:[SDECodeProjectUrlScheme getArticleRSSForCategory:3]]];
    [mutableArticleFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"Java" AndUrl:[SDECodeProjectUrlScheme getArticleRSSForCategory:10]]];
    [mutableArticleFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"LAMP" AndUrl:[SDECodeProjectUrlScheme getArticleRSSForCategory:12]]];
    [mutableArticleFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"MFC/C++" AndUrl:[SDECodeProjectUrlScheme getArticleRSSForCategory:2]]];
    [mutableArticleFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"Mobile" AndUrl:[SDECodeProjectUrlScheme getArticleRSSForCategory:18]]];
    [mutableArticleFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"SQL" AndUrl:[SDECodeProjectUrlScheme getArticleRSSForCategory:9]]];
    [mutableArticleFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"Tech Lead" AndUrl:[SDECodeProjectUrlScheme getArticleRSSForCategory:19]]];
    [mutableArticleFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"VB.NET" AndUrl:[SDECodeProjectUrlScheme getArticleRSSForCategory:6]]];
    
    articleFeeds = [[NSArray alloc] initWithArray:mutableArticleFeeds];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return articleFeeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RSSArticleCategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    SDECodeProjectFeed *articleCategory = [articleFeeds objectAtIndex:indexPath.row];
    
    static NSInteger nameTag = 100;
    ((UILabel*)[cell viewWithTag:nameTag]).text = articleCategory.Name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.categorySelectionDelegate selectedFeed:[articleFeeds objectAtIndex:indexPath.row]];
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
