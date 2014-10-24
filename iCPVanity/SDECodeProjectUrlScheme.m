//
//  SDECodeProjectUrlScheme.m
//  iCPVanity
//
//  Created by serge desmedt on 25/01/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECodeProjectUrlScheme.h"

@implementation SDECodeProjectUrlScheme

+ (NSString*)baseUrl
{
    return @"http://www.codeproject.com";
}

+ (NSString*)getMemberProfilePageUrl:(int)memberId
{
    return [[SDECodeProjectUrlScheme baseUrl] stringByAppendingString: [NSString stringWithFormat: @"/script/Membership/view.aspx?mid=%d", memberId]];
}

+ (NSString*)getMemberArticlesPageUrl:(int)memberId
{
    return [[SDECodeProjectUrlScheme baseUrl] stringByAppendingString: [NSString stringWithFormat: @"/script/Articles/MemberArticles.aspx?amid=%d", memberId]];
}

+ (NSString*)getMemberReputationGraphUrl:(int)memberId
{
    return [[SDECodeProjectUrlScheme baseUrl] stringByAppendingString: [NSString stringWithFormat: @"/script/Reputation/ReputationGraph.aspx?mid=%d", memberId]];
}

+ (NSString*)getArticleRSSForCategory:(int)category;
{
    return  [[SDECodeProjectUrlScheme baseUrl] stringByAppendingString: [NSString stringWithFormat:@"/webservices/articlerss.aspx?cat=%d", category]];
}

@end
