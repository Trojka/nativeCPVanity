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


@interface SDECodeProjectMember()
{
}

@end


@implementation SDECodeProjectMember

@synthesize ReputationGraphUrl = _reputationGraphUrl;

- (NSString*) ReputationGraphUrl {
    if(_reputationGraphUrl == NULL)
    {
        _reputationGraphUrl == [SDECodeProjectUrlScheme getMemberProfilePageUrl:self.MemberId];
    }
    return _reputationGraphUrl;
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
    }
    
    return self;
}

@end
