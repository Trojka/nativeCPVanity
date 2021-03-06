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

@property (nonatomic, readwrite) NSString* imageUrl;

@property (nonatomic, readwrite) NSString* Reputation;

@property (nonatomic, readonly) NSString* reputationGraphUrl;

@property (nonatomic, readwrite) int ArticleCount;

@property (nonatomic, readwrite) NSString* AvgArticleRating;

@property (nonatomic, readwrite) int BlogCount;

@property (nonatomic, readwrite) NSString* AvgBlogRating;

@property (nonatomic, readwrite) UIImage* Gravatar;

- (id)initWithId:(int)memberId;

- (id)initWithManagedObject:(NSManagedObject*) managedObject;

@end
