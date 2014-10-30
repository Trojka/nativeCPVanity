//
//  SDECPUserArticleViewController.m
//  iCPVanity
//
//  Created by serge desmedt on 8/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECPPageViewController.h"

@interface SDECPPageViewController ()

@end

@implementation SDECPPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString* link = self.Url;
    NSURL *myURL = [NSURL URLWithString: link];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
