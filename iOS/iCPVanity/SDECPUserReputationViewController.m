//
//  SDECPUserReputationViewController.m
//  iCPVanity
//
//  Created by serge desmedt on 3/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECPUserReputationViewController.h"

@interface SDECPUserReputationViewController ()
{
    UIActivityIndicatorView *activityView;
    
    NSMutableData *reputationGraphData;
    NSURLConnection *reputationGraphConnection;    
}

@end

@implementation SDECPUserReputationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* imagUrl = [self.CodeprojectMember.ReputationGraphUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    reputationGraphData = [NSMutableData new];
    reputationGraphConnection =[NSURLConnection connectionWithRequest:
                            [NSURLRequest requestWithURL:
                             [NSURL URLWithString:imagUrl]]
                                                         delegate:self];

    
    activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake (120.0, 185.0, 80, 80)];
    activityView.color = [UIColor darkGrayColor];
    
    [self.view addSubview:activityView];
    
    [activityView startAnimating];

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [reputationGraphData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [activityView stopAnimating];
    
    UIImage *image = [[UIImage alloc] initWithData:reputationGraphData];
	
    [self.ReputationGraph setImage:image];
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
