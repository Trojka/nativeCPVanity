//
//  SDECodeProjectUser.h
//  iCPVanity
//
//  Created by serge desmedt on 25/01/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDECodeProjectMemberDelegate <NSObject>

- (void) codeprojectMemberAvailable;

- (void) codeprojectMemberProfileAvailable;

- (void) codeprojectMemberArticleAvailable;

@end

@interface SDECodeProjectMember : NSObject

@property (nonatomic, assign, readwrite) id<SDECodeProjectMemberDelegate> delegate;

@property (nonatomic, readonly) int MemberId;

@property (nonatomic, readwrite) NSString* MemberName;

@property (nonatomic, readonly) NSString* ImageUrl;

@property (nonatomic, readonly) NSString* Reputation;

@property (nonatomic, readonly) NSString* ReputationGraphUrl;

@property (nonatomic, readonly) NSArray* ArticleList;

@property (nonatomic, readonly) NSString* AvgArticleRating;

@property (nonatomic, readonly) NSArray* BlogList;

@property (nonatomic, readonly) NSString* AvgBlogRating;

- (id)initWithId:(int)memberId delegate:(id <SDECodeProjectMemberDelegate>)delegate;

@end
