//
//  SDECPRssViewController.m
//  iCPVanity
//
//  Created by serge desmedt on 16/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECPRssViewController.h"

#import "SDECodeProjectUrlScheme.h"
#import "SDERSSFeed.h"
#import "SDERSSItem.h"
#import "SDECPArticleCategoryViewController.h"
#import "SDECPPageViewController.h"

@interface SDECPRssViewController ()
{
    SDERSSFeed *rssFeed;
    
    //UIActivityIndicatorView *activityView;
}

@end

@implementation SDECPRssViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.EntriesView.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadRSS];
}

- (void) loadRSS
{
    self.FeedLabel.text = self.Feed.Name;
    
    NSLog(@"%@", self.Feed.Url);
    NSURL* rssUrl = [[NSURL alloc] initWithString:self.Feed.Url];
    
    rssFeed = [[SDERSSFeed alloc] initWithContentsOfURL:rssUrl];
    rssFeed.delegate = self;
    [rssFeed loadRSS];
    
    //[activityView startAnimating];
}

- (void) feedLoaded
{
    //[activityView stopAnimating];
    
	self.Entries = rssFeed.Items;
    self.EntriesView.dataSource = self;
    
    [self.EntriesView reloadData];
}

- (void) selectedFeed:(SDECodeProjectFeed*) feed
{
    self.Feed = feed;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize) heightOfText:(NSString*) text withWidth:(NSInteger) width
{
    UIFont* font = [UIFont systemFontOfSize:15.0];
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = font;
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    
    CGRect paragraphRect =
    [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                       options:(NSStringDrawingUsesLineFragmentOrigin)
                    attributes:attributes
                       context:nil];
    
    return paragraphRect.size;
}

- (NSString*) entryCellIdentifier
{
    return @"";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.Entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self entryCellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    SDERSSItem *article = [self.Entries objectAtIndex:indexPath.row];
    
    static NSInteger titleTag = 100;
    static NSInteger authorTag = 101;
    //static NSInteger dateTag= 102;
    static NSInteger descriptionTag = 103;
    
    NSString* articleDescription = article.Description;
    
    ((UILabel*)[cell viewWithTag:titleTag]).text = article.Title;
    ((UILabel*)[cell viewWithTag:authorTag]).text = article.Author;
    //((UILabel*)[cell viewWithTag:dateTag]).text = article.Date;
    
    ((UILabel*)[cell viewWithTag:descriptionTag]).text = articleDescription;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDERSSItem *article = [self.Entries objectAtIndex:indexPath.row];
    
    NSString* articleDescription = article.Description;
    CGFloat textHeight = [self heightOfText:articleDescription withWidth:267].height;
    
    CGFloat height = [self roundValue:textHeight ToNearestMultipleOf:18.5f] + 50;
    
    return height;
    
}

-(CGFloat)roundValue:(CGFloat) value ToNearestMultipleOf:(CGFloat) multiple
{
    int roundedMultiple = (int)round(value/multiple);
    return roundedMultiple * multiple;
}


@end
