//
//  SDECodeProjectMemberDatabase.m
//  iCPVanity
//
//  Created by serge desmedt on 24/10/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECodeProjectMemberDatabase.h"
#import "SDECodeProjectMember.h"

@implementation SDECodeProjectMemberDatabase

- (NSArray*)getMemberList {
    NSMutableArray* memberList = [[NSMutableArray alloc] init];
    
    SDECodeProjectMember* member1 = [[SDECodeProjectMember alloc] init];
    member1.MemberName = @"Ikke";
    [memberList addObject:member1];
    
    SDECodeProjectMember* member2 = [[SDECodeProjectMember alloc] init];
    member2.MemberName = @"Dienandern";
    [memberList addObject:member2];
    
    NSArray* result = [[NSArray alloc] initWithArray:memberList];
    
    return result;
}

@end
