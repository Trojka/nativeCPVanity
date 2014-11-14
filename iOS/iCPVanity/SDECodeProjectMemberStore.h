//
//  SDECodeProjectMemberStore.h
//  iCPVanity
//
//  Created by serge desmedt on 8/11/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDECodeProjectMember.h"

@interface SDECodeProjectMemberStore : NSObject
{
    NSManagedObjectContext* managedObjectContext;
}

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (NSArray*) getAllMembers;

+ (UIImage*) getMemberGravatar:(SDECodeProjectMember*) member;

- (void) saveMember:(SDECodeProjectMember*) member;

- (void) deleteMember:(int) memberId;

@end
