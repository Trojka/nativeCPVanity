//
//  SDECodeProjectMember.m
//  iCPVanity
//
//  Created by serge desmedt on 25/01/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECodeProjectMember.h"
#import "SDECodeProjectArticle.h"
#import "SDECodeProjectUrlScheme.h"


@implementation SDECodeProjectMember

- (NSString*) reputationGraphUrl {
    
    NSLog(@"Getting reputationGraphUrl");
    return [SDECodeProjectUrlScheme getMemberReputationGraphUrl:self.MemberId];
}

- (id)initWithId:(int)memberId
{
    self = [super init];
    
    if(self)
    {
        self.MemberId = memberId;
    }
    
    return self;
}

- (id)initWithManagedObject:(NSManagedObject*) managedObject
{
    self = [super init];
    
    if(self)
    {
        self.MemberId = [(NSNumber*)[managedObject valueForKey:@"id"] integerValue];
        self.MemberName = [managedObject valueForKey:@"name"];
        self.ArticleCount = [(NSNumber*)[managedObject valueForKey:@"article_count"] integerValue];
        self.BlogCount = [(NSNumber*)[managedObject valueForKey:@"blog_count"] integerValue];
        self.Reputation = [managedObject valueForKey:@"reputation"];
    }
    
    return self;
}

@end
