//
//  SDECodeProjectUser.m
//  iCPVanity
//
//  Created by serge desmedt on 25/01/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECodeProjectMember.h"
#import "SDECodeProjectUrlScheme.h"
#import "SDECodeProjectArticle.h"


@interface SDECodeProjectMember()
{
    NSMutableData *articlePageData;
    NSURLConnection *articlePageConnection;
    
    NSMutableData *profilePageData;
    NSURLConnection *profilePageConnection;
}

@property (atomic, readwrite) Boolean ProfilePageLoaded;

@property (atomic, readwrite) Boolean ArticlePageLoaded;

@property (nonatomic, readwrite) int MemberId;

//@property (nonatomic, readwrite) NSString* MemberName;

@property (nonatomic, readwrite) NSString* ImageUrl;

@property (nonatomic, readwrite) NSString* Reputation;

@property (nonatomic, readwrite) NSString* ReputationGraphUrl;

@property (nonatomic, readwrite) NSArray* ArticleList;

@property (nonatomic, readwrite) NSString* AvgArticleRating;

@property (nonatomic, readwrite) NSArray* BlogList;

@property (nonatomic, readwrite) NSString* AvgBlogRating;

@end

@implementation SDECodeProjectMember

- (id)initWithId:(int)memberId delegate:(id<SDECodeProjectMemberDelegate>)delegate
{
    self = [super init];
    
    if(self)
    {
        self.MemberId = memberId;
        self.delegate = delegate;
        
        self.ReputationGraphUrl = [SDECodeProjectUrlScheme getMemberReputationGraphUrl:self.MemberId];
        
        NSString* memberProfilePageUrl = [SDECodeProjectUrlScheme getMemberProfilePageUrl:self.MemberId];
        profilePageData = [NSMutableData new];
        profilePageConnection =[NSURLConnection connectionWithRequest:
                                [NSURLRequest requestWithURL:
                                 [NSURL URLWithString:memberProfilePageUrl]]
                                                             delegate:self];
        
        articlePageData = [NSMutableData new];
        articlePageConnection =[NSURLConnection connectionWithRequest:
                       [NSURLRequest requestWithURL:
                        [NSURL URLWithString:[SDECodeProjectUrlScheme getMemberArticlesPageUrl:self.MemberId]]]
                                                    delegate:self];

    }
    
    return self;
}


- (void)fillMemberProfileFromProfilePage:(NSString*) page
{
    // <img id="ctl00_MC_Prof_MemberImage" class="padded-top" src="/script/Membership/Images/member_unknown.gif"
    // <img id="ctl\d*_MC_Prof_MemberImage[\s\S]*?src="([\s\S]*?)"
    NSString* imageUrlMatchingPattern = @"<img id=\"ctl\\d*_MC_Prof_MemberImage[\\s\\S]*?src=\"([\\s\\S]*?)\"";
    NSString* imageUrl = [self captureForPattern: imageUrlMatchingPattern inText:page];
    
    // Sometimes the image URL allready has the codeproject baseurl in it, other times it hasn't
    if([imageUrl rangeOfString:[SDECodeProjectUrlScheme baseUrl]].location == NSNotFound)
    {
        self.ImageUrl = [[SDECodeProjectUrlScheme baseUrl] stringByAppendingString:imageUrl];
    }
    else
    {
        self.ImageUrl = imageUrl;
    }
    NSLog(@"ImageUrl: %@", self.ImageUrl);
    
    // <span id="ctl00_MC_Prof_TotalRep" class="large-text">5,072</span>
    // <span id="ctl\d*_MC_Prof_TotalRep[\s\S]*?>([0-9,]*)
    NSString* reputationMatchingPattern = @"<span id=\"ctl\\d*_MC_Prof_TotalRep[\\s\\S]*?>([0-9,]*)";
    self.Reputation = [self captureForPattern: reputationMatchingPattern inText:page];
    NSLog(@"Reputation: %@", self.Reputation);
    
}


- (void)fillMemberProfileFromArticlePage:(NSString*) page
{
    // Articles by Serge Desmedt (Articles: 6, Technical Blogs: 2)
    // Articles by [^\(]*\(
    NSString* nameMatchingPattern = @"Articles by [^\\(]*\\(";
    NSArray *matches = [self matchesForPattern: nameMatchingPattern inText:page];
    
    _MemberName = @"Unknown";
    if (matches.count != 0)
    {
        NSTextCheckingResult *match = (NSTextCheckingResult*)matches.firstObject;
        NSString* matchString = [page substringWithRange:match.range];
        
        NSString* namePreFixPattern = @"Articles by ";
        NSRange nameRange = NSMakeRange (namePreFixPattern.length, matchString.length - namePreFixPattern.length);
        _MemberName = [matchString substringWithRange:nameRange];
        if([_MemberName rangeOfString:@"("].location != NSNotFound)
        {
            nameRange = NSMakeRange (0, _MemberName.length - 1);
            _MemberName = [_MemberName substringWithRange:nameRange];
        }
    }
    
    // Average article rating: 4.66
    // verage article rating: ([0-9./]*)
    NSString* avgArticleRatingMatchingPattern = @"verage article rating: ([0-9.]*)";
    self.AvgArticleRating = [self captureForPattern: avgArticleRatingMatchingPattern inText:page];
    NSLog(@"AvgArticleRating: %@", self.AvgArticleRating);
    
    // Average blogs rating: 5.00
    // verage blogs rating: ([0-9./]*)
    NSString* avgBlogRatingMatchingPattern = @"verage blogs rating: ([0-9.]*)";
    self.AvgBlogRating = [self captureForPattern: avgBlogRatingMatchingPattern inText:page];
    NSLog(@"AvgBlogRating: %@", self.AvgBlogRating);
    
}


- (void)fillMemberArticlesFromPage:(NSString*) page
{
    // <tr id="ctl00_MC_AR_ctl01_CAR_MainArticleRow" valign="top">
    // <tr id="ctl\d*_MC_.R_ctl\d*_CAR_MainArticleRow[\s\S]*?</table>[\s\S]*?</tr>
    NSString* articleMatchingPattern = @"<tr id=\"ctl\\d*_MC_.R_ctl\\d*_CAR_MainArticleRow[\\s\\S]*?</table>[\\s\\S]*?</tr>";
    NSArray *matches = [self matchesForPattern: articleMatchingPattern inText:page];
    
    NSMutableArray* articleArray = [[NSMutableArray alloc] initWithCapacity:matches.count];
    NSMutableArray* blogArray = [[NSMutableArray alloc] initWithCapacity:matches.count];
    self.ArticleList = articleArray;
    self.BlogList = blogArray;
    
    for (NSTextCheckingResult* articleMatch in matches)
    {
        SDECodeProjectArticle *article = [[SDECodeProjectArticle alloc] init];
        
        NSString* matchString = [page substringWithRange:articleMatch.range];
        
        //<a id="ctl\d*_MC_.R_ctl\d*_CAR_Title[\s\S]*?href="([\s\S]*?)">([\s\S]*?)</a>
        NSString* titleMatchingPattern = @"<a id=\"ctl\\d*_MC_.R_ctl\\d*_CAR_Title[\\s\\S]*?href=\"([\\s\\S]*?)\">([\\s\\S]*?)</a>";
        NSArray *titleMatches = [self matchesForPattern: titleMatchingPattern inText:matchString];
        if(titleMatches.count != 0)
        {
            NSTextCheckingResult* titleMatch = [titleMatches firstObject];
            NSRange linkRange = [titleMatch rangeAtIndex:1];
            article.Link = [[SDECodeProjectUrlScheme baseUrl] stringByAppendingString:[matchString substringWithRange:linkRange]];
            NSLog(@"Link: %@", article.Link);
            NSRange titleRange = [titleMatch rangeAtIndex:2];
            article.Title = [matchString substringWithRange:titleRange];
            NSLog(@"Title: %@", article.Title);
        }

        
        NSString* descriptionMatchingPattern = @"<span id=\"ctl\\d*_MC_.R_ctl\\d*_CAR_Description\">([\\s\\S]*?)</span>";
        article.Description = [self captureForPattern: descriptionMatchingPattern inText:matchString];
        NSLog(@"Description: %@", article.Description);
        
        NSString* postedMatchingPattern = @"osted: ([123]\\d [A-z][A-z][A-z] 20[012]\\d)";
        article.DatePosted = [self captureForPattern: postedMatchingPattern inText:matchString];
        NSLog(@"Posted: %@", article.DatePosted);
        
        NSString* updatedMatchingPattern = @"pdated: <b>([123]*\\d [A-z][A-z][A-z] 20[012]\\d)<";
        article.DateUpdated = [self captureForPattern: updatedMatchingPattern inText:matchString];
        NSLog(@"Updated: %@", article.DateUpdated);
        
        NSString* viewsMatchingPattern = @"iew.*?: ([0-9,]*)";
        article.Views = [self captureForPattern: viewsMatchingPattern inText:matchString];
        NSLog(@"Views: %@", article.Views);
        
        NSString* ratingMatchingPattern = @"ating.*?: ([0-9./]*)";
        article.Rating = [self captureForPattern: ratingMatchingPattern inText:matchString];
        NSLog(@"Rating: %@", article.Rating);
        
        NSString* votesMatchingPattern = @"ote.*?: ([0-9]*)";
        article.Votes = [self captureForPattern: votesMatchingPattern inText:matchString];
        NSLog(@"Votes: %@", article.Rating);
        
        NSString* popularityMatchingPattern = @"opularity: ([0-9.]*)";
        article.Popularity = [self captureForPattern: popularityMatchingPattern inText:matchString];
        NSLog(@"Popularity: %@", article.Popularity);
        
        NSString* bookmarkedMatchingPattern = @"ookmark.*?: ([0-9]*)";
        article.Bookmarked = [self captureForPattern: bookmarkedMatchingPattern inText:matchString];
        NSLog(@"Bookmarked: %@", article.Bookmarked);
        
        NSString* downloadedMatchingPattern = @"ownload.*?: ([0-9]*)";
        article.Downloaded = [self captureForPattern: downloadedMatchingPattern inText:matchString];
        NSLog(@"Downloaded: %@", article.Downloaded);
        
        NSLog(@"Article completed.");
        
        if(article.IsArticle)
            [articleArray addObject:article];
        else
            [blogArray addObject:article];

    }
}


- (NSArray*)matchesForPattern:(NSString*)pattern inText:(NSString*)text {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                             regularExpressionWithPattern:pattern
                                             options:NSRegularExpressionCaseInsensitive
                                             error:&error];
    if (error)
    {
        NSLog(@"Couldn't create regex with given string and options");
    }
    
    NSRange matchRange = NSMakeRange(0, text.length);
    return [regex matchesInString:text options:0 range:matchRange];
}


- (NSString*)captureForPattern:(NSString*)pattern inText:(NSString*)text {
    NSString *captureString = @"Error";
    NSArray *matches = [self matchesForPattern: pattern inText:text];
    if(matches.count != 0)
    {
        NSTextCheckingResult* firstMatch = [matches firstObject];
        NSRange matchRange = [firstMatch rangeAtIndex:1];
        captureString = [text substringWithRange:matchRange];
    }
    
    return captureString;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(connection == profilePageConnection)
        [profilePageData appendData:data];
    
    if(connection == articlePageConnection)
        [articlePageData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if(connection == profilePageConnection)
    {
        NSString *profilePage = [[NSString alloc]initWithData:profilePageData encoding:NSASCIIStringEncoding];
        
        [self fillMemberProfileFromProfilePage:profilePage];
        
        self.ProfilePageLoaded = true;

        if(self.delegate != NULL)
            [self.delegate codeprojectMemberProfileAvailable];
    }

    if(connection == articlePageConnection)
    {
        NSString *articlePage = [[NSString alloc]initWithData:articlePageData encoding:NSASCIIStringEncoding];
        
        [self fillMemberProfileFromArticlePage:articlePage];
        [self fillMemberArticlesFromPage:articlePage];
        
        self.ArticlePageLoaded = true;
        
        if(self.delegate != NULL)
            [self.delegate codeprojectMemberArticleAvailable];
    }
    
    if(self.ProfilePageLoaded && self.ArticlePageLoaded)
    {
        if(self.delegate != NULL)
            [self.delegate codeprojectMemberAvailable];
    }
}


@end
