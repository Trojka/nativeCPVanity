//
//  SDECPArticleViewController.m
//  iCPVanity
//
//  Created by serge desmedt on 25/01/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECPArticleViewController.h"
#import "SDECodeProjectUrlScheme.h"
#import "SDECPArticleCategoryViewController.h"
#import "SDECPPageViewController.h"
#import "SDERSSItem.h"

@implementation SDECPArticleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.Feed = [[SDECodeProjectFeed alloc] initWithName:@"All" AndUrl:[SDECodeProjectUrlScheme getArticleRSSForCategory:1]];

}

- (NSString*) entryCellIdentifier
{
    return @"RSSArticleCell";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RSSArticleCategory"])
    {
        SDECPArticleCategoryViewController *categoryViewController = (SDECPArticleCategoryViewController*)segue.destinationViewController;
        
        categoryViewController.categorySelectionDelegate = self;
    }
    else if([segue.identifier isEqualToString:@"RSSArticle"]) {
        SDECPPageViewController *pageViewController = (SDECPPageViewController*)segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.EntriesView indexPathForSelectedRow];
        
        pageViewController.Url = ((SDERSSItem*)[self.Entries objectAtIndex:indexPath.row]).Link;
    }
}

@end
