//
//  SDECPUserArticleViewController.h
//  iCPVanity
//
//  Created by serge desmedt on 8/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDECodeProjectArticle.h"

@interface SDECPPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, readwrite) NSString* Url;

@end
