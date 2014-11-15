//
//  SDECodeProjectWeb.h
//  iCPVanity
//
//  Created by serge desmedt on 8/11/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDECodeProjectMember.h"
#import "SDECodeProjectMemberArticles.h"

@protocol SDECodeProjectWebDelegate <NSObject>

- (void) codeprojectMemberAvailable;

- (void) codeprojectMemberProfileAvailable;

- (void) codeprojectMemberArticleAvailable;

- (void) codeprojectLogoAvailable;

@end

@interface SDECodeProjectWeb : NSObject

-(void)fillMember:(SDECodeProjectMember*)member delegate:(id <SDECodeProjectWebDelegate>)delegate;

-(void)fillMemberArticles:(SDECodeProjectMemberArticles*)memberArticles delegate:(id <SDECodeProjectWebDelegate>)delegate;

-(void)fillLogo:(UIImage**)logo delegate:(id <SDECodeProjectWebDelegate>)delegate;

@end
