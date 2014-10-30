//
//  SDECodeProjectUrlScheme.h
//  iCPVanity
//
//  Created by serge desmedt on 25/01/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDECodeProjectUrlScheme : NSObject

+ (NSString*)baseUrl;

+ (NSString*)getMemberProfilePageUrl:(int)memberId;

+ (NSString*)getMemberArticlesPageUrl:(int)memberId;

+ (NSString*)getMemberReputationGraphUrl:(int)memberId;

+ (NSString*)getArticleRSSForCategory:(int)category;

@end
