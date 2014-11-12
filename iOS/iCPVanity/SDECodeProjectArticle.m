//
//  SDECodeProjectArticle.m
//  iCPVanity
//
//  Created by serge desmedt on 29/01/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECodeProjectArticle.h"

@implementation SDECodeProjectArticle

- (Boolean)IsArticle {
    // Article posts do NOT contain the words [Technical Blog]
    return [self.Title rangeOfString:@"[Technical Blog]"].location == NSNotFound;
}

@end
