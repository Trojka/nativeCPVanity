//
//  SDECPForumCategoryViewController.m
//  iCPVanity
//
//  Created by serge desmedt on 16/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECPForumCategoryViewController.h"

@implementation SDECPForumCategoryViewController

NSArray* forumFeeds;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray* mutableForumFeeds = [[NSMutableArray alloc] init];
    
    [mutableForumFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"Lounge" AndUrl:@"http://www.codeproject.com/webservices/LoungeRss.aspx"]];
    [mutableForumFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"Wicked Code" AndUrl:@"http://www.codeproject.com/webservices/WickedCodeRSS.aspx"]];
    [mutableForumFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"Coding Horror" AndUrl:@"http://www.codeproject.com/webservices/CodingHorrorsRSS.aspx"]];
    [mutableForumFeeds addObject:[[SDECodeProjectFeed alloc] initWithName:@"Messages" AndUrl:@"http://www.codeproject.com/WebServices/MessageRSS.aspx?fid=1536756"]];
    
    forumFeeds = [[NSArray alloc] initWithArray:mutableForumFeeds];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return forumFeeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RSSForumCategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    SDECodeProjectFeed *forumCategory = [forumFeeds objectAtIndex:indexPath.row];
    
    static NSInteger nameTag = 100;
    ((UILabel*)[cell viewWithTag:nameTag]).text = forumCategory.Name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.categorySelectionDelegate selectedFeed:[forumFeeds objectAtIndex:indexPath.row]];
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
