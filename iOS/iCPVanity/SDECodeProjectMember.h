//
//  SDECodeProjectMember.h
//  iCPVanity
//
//  Created by serge desmedt on 25/01/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDECodeProjectMember : NSObject

@property (nonatomic, readwrite) int MemberId;

@property (nonatomic, readwrite) NSString* MemberName;

@property (nonatomic, readwrite) NSString* ImageUrl;

@property (nonatomic, readwrite) NSString* Reputation;

@property (nonatomic, readwrite) NSString* ReputationGraphUrl;

@property (nonatomic, readwrite) NSArray* ArticleList;

@property (nonatomic, readwrite) NSString* AvgArticleRating;

@property (nonatomic, readwrite) NSArray* BlogList;

@property (nonatomic, readwrite) NSString* AvgBlogRating;

- (id)initWithId:(int)memberId;

- (id)initWithManagedObject:(NSManagedObject*) managedObject;

@end
