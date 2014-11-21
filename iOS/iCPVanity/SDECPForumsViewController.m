//
//  SDECPLoungeViewController.m
//  iCPVanity
//
//  Created by serge desmedt on 25/01/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECPForumsViewController.h"

#import "SDECodeProjectUrlScheme.h"
#import "SDERSSFeed.h"
#import "SDERSSItem.h"
#import "SDECPForumCategoryViewController.h"
#import "SDECPPageViewController.h"

@implementation SDECPForumsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.Feed = [[SDECodeProjectFeed alloc] initWithName:@"All" AndUrl:@"http://www.codeproject.com/webservices/LoungeRss.aspx"];
}

- (NSString*) entryCellIdentifier
{
    return @"RSSForumCell";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RSSForumCategory"])
    {
        SDECPForumCategoryViewController *categoryViewController = (SDECPForumCategoryViewController*)segue.destinationViewController;
        
        categoryViewController.categorySelectionDelegate = self;
    }
    //else if([segue.identifier isEqualToString:@"RSSForum"]) {
    //    SDECPPageViewController *pageViewController = (SDECPPageViewController*)segue.destinationViewController;
    //
    //    NSIndexPath *indexPath = [self.EntriesView indexPathForSelectedRow];
    //
    //    pageViewController.Url = ((SDERSSItem*)[self.Entries objectAtIndex:indexPath.row]).Link;
    //}
}

@end
