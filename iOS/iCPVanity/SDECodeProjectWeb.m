//
//  SDECodeProjectWeb.m
//  iCPVanity
//
//  Created by serge desmedt on 8/11/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECodeProjectWeb.h"
#import "SDECodeProjectUrlScheme.h"
#import "SDECodeProjectArticle.h"

@interface SDECodeProjectWeb()
{
    NSMutableData *articlePageData;
    NSURLConnection *articlePageConnection;
    
    NSMutableData *profilePageData;
    NSURLConnection *profilePageConnection;
    
    NSData *homePageData;
    NSURLConnection *homePageConnection;
}

@property (atomic, readwrite) Boolean ProfilePageLoaded;

@property (atomic, readwrite) Boolean ArticlePageLoaded;

@end


@implementation SDECodeProjectWeb

SDECodeProjectMember* memberToFill;
SDECodeProjectMemberArticles* memberArticlesToFill;
UIImage* logoToFill;

id<SDECodeProjectWebDelegate> progressDelegate;

-(void)fillMember:(SDECodeProjectMember *)member delegate:(id<SDECodeProjectWebDelegate>)delegate
{
    progressDelegate = delegate;
    memberToFill = member;
    memberArticlesToFill = NULL;
    
    //member.ReputationGraphUrl = [SDECodeProjectUrlScheme getMemberReputationGraphUrl:member.MemberId];
    
    NSString* memberProfilePageUrl = [SDECodeProjectUrlScheme getMemberProfilePageUrl:member.MemberId];
    profilePageData = [NSMutableData new];
    profilePageConnection =[NSURLConnection connectionWithRequest:
                            [NSURLRequest requestWithURL:
                             [NSURL URLWithString:memberProfilePageUrl]]
                                                         delegate:self];
    
    NSString* memberArticlesPageUrl = [SDECodeProjectUrlScheme getMemberArticlesPageUrl:member.MemberId];
    articlePageData = [NSMutableData new];
    articlePageConnection =[NSURLConnection connectionWithRequest:
                            [NSURLRequest requestWithURL:
                             [NSURL URLWithString:memberArticlesPageUrl]]
                                                         delegate:self];
}


-(void)fillMemberArticles:(SDECodeProjectMemberArticles*)memberArticles delegate:(id <SDECodeProjectWebDelegate>)delegate
{
    progressDelegate = delegate;
    memberArticlesToFill = memberArticles;
    memberToFill = NULL;
    
    NSString* memberArticlesPageUrl = [SDECodeProjectUrlScheme getMemberArticlesPageUrl:memberArticles.MemberId];
    articlePageData = [NSMutableData new];
    articlePageConnection =[NSURLConnection connectionWithRequest:
                            [NSURLRequest requestWithURL:
                             [NSURL URLWithString:memberArticlesPageUrl]]
                                                         delegate:self];
    
}


-(void)fillLogo:(UIImage**)logo delegate:(id<SDECodeProjectWebDelegate>)delegate
{
    //progressDelegate = delegate;
    //logoToFill = logo;
    
    NSString* homePageUrl = [SDECodeProjectUrlScheme baseUrl];
    
    //homePageData = [NSMutableData new];
    //homePageConnection =[NSURLConnection connectionWithRequest:
    //                     [NSURLRequest requestWithURL:
    //                      [NSURL URLWithString:homePageUrl]]
    //                                                  delegate:self];
    
    NSURLResponse* response = nil;
    NSError* error = nil;
    homePageData = [NSURLConnection
                    sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:homePageUrl]]
                        returningResponse:&response
                        error:&error];
    
    NSString *homePage = [[NSString alloc]initWithData:homePageData encoding:NSASCIIStringEncoding];

    [self fillLogo:logo fromPage:homePage];

}


- (void)fillMemberProfile:(SDECodeProjectMember *)member fromProfilePage:(NSString*) page
{
    // <img id="ctl00_MC_Prof_MemberImage" class="padded-top" src="/script/Membership/Images/member_unknown.gif"
    // <img id="ctl\d*_MC_Prof_MemberImage[\s\S]*?src="([\s\S]*?)"
    NSString* imageUrlMatchingPattern = @"<img id=\"ctl\\d*_MC_Prof_MemberImage[\\s\\S]*?src=\"([\\s\\S]*?)\"";
    NSString* imageUrl = [self captureForPattern: imageUrlMatchingPattern inText:page];
    
    memberToFill.imageUrl = imageUrl;
    NSLog(@"ImageUrl: %@", memberToFill.imageUrl);
    
    // <span id="ctl00_MC_Prof_TotalRep" class="large-text">5,072</span>
    // <span id="ctl\d*_MC_Prof_TotalRep[\s\S]*?>([0-9,]*)
    NSString* reputationMatchingPattern = @"<span id=\"ctl\\d*_MC_Prof_TotalRep[\\s\\S]*?>([0-9,]*)";
    memberToFill.Reputation = [self captureForPattern: reputationMatchingPattern inText:page];
    NSLog(@"Reputation: %@", memberToFill.Reputation);
    
}


- (void)fillMemberProfile:(SDECodeProjectMember *)member fromArticlePage:(NSString*) page
{
    // Articles by Serge Desmedt (Articles: 6, Technical Blogs: 2)
    // Articles by [^\(]*\(
    NSString* nameMatchingPattern = @"Articles by [^\\(]*\\(";
    NSArray *matches = [self matchesForPattern: nameMatchingPattern inText:page];
    
    memberToFill.MemberName = @"Unknown";
    if (matches.count != 0)
    {
        NSTextCheckingResult *match = (NSTextCheckingResult*)matches.firstObject;
        NSString* matchString = [page substringWithRange:match.range];
        
        NSString* namePreFixPattern = @"Articles by ";
        NSRange nameRange = NSMakeRange (namePreFixPattern.length, matchString.length - namePreFixPattern.length);
        memberToFill.MemberName = [matchString substringWithRange:nameRange];
        if([memberToFill.MemberName rangeOfString:@"("].location != NSNotFound)
        {
            nameRange = NSMakeRange (0, memberToFill.MemberName.length - 1);
            memberToFill.MemberName = [memberToFill.MemberName substringWithRange:nameRange];
        }
    }
    
    // Articles by Serge Desmedt (Articles: 6, Technical Blogs: 2)
    // rticles by [^\(]*\([Aa]rticles?: ?([0-9]*)
    NSString* articleCountMatchingPattern = @"rticles by [^\\(]*\\([Aa]rticles?: ?([0-9]*)";
    NSString* articleCountAsString = [self captureForPattern: articleCountMatchingPattern inText: page];
    NSInteger articleCount = 0;
    if(articleCountAsString != NULL) {
        NSScanner *articleCountscanner = [NSScanner scannerWithString:articleCountAsString];
        [articleCountscanner scanInteger: &articleCount];
    }
    memberToFill.ArticleCount = articleCount;
    NSLog(@"ArticleCount: %d", memberToFill.ArticleCount);
    
    // Articles by Serge Desmedt (Articles: 6, Technical Blogs: 2)
    // rticles by [^\(]*\(([Aa]rticles?: ?[0-9]*, ?)?[Tt]echnical [Bb]logs?: ?([0-9]*)\)
    NSString* blogCountMatchingPattern = @"rticles by [^\\(]*\\(([Aa]rticles?: ?[0-9]*, ?)?[Tt]echnical [Bb]logs?: ?([0-9]*)\\)";
    NSString* blogCountAsString = [self captureForPattern: blogCountMatchingPattern atIndex:2 inText:page];
    NSInteger blogCount = 0;
    if(blogCountAsString != NULL) {
        NSScanner *blogCountscanner = [NSScanner scannerWithString:blogCountAsString];
        [blogCountscanner scanInteger: &blogCount];
    }
    memberToFill.BlogCount = blogCount;
    NSLog(@"BlogCount: %d", memberToFill.BlogCount);
    
    // Average article rating: 4.66
    // verage article rating: ([0-9./]*)
    NSString* avgArticleRatingMatchingPattern = @"verage article rating: ([0-9.]*)";
    NSString* avgArticleRating = [self captureForPattern: avgArticleRatingMatchingPattern inText:page];
    if (avgArticleRating == NULL) {
        avgArticleRating = @"-";
    }
    memberToFill.AvgArticleRating = avgArticleRating;
    NSLog(@"AvgArticleRating: %@", memberToFill.AvgArticleRating);
    
    // Average blogs rating: 5.00
    // verage blogs rating: ([0-9./]*)
    NSString* avgBlogRatingMatchingPattern = @"verage blogs rating: ([0-9.]*)";
    NSString* avgBlogRating = [self captureForPattern: avgBlogRatingMatchingPattern inText:page];
    if (avgBlogRating == NULL) {
        avgBlogRating = @"-";
    }
    memberToFill.AvgBlogRating = avgBlogRating;
    NSLog(@"AvgBlogRating: %@", memberToFill.AvgBlogRating);
    
}


- (void)fillMemberArticles:(SDECodeProjectMemberArticles*)memberArticles fromPage:(NSString*) page
{
    // <tr id="ctl00_MC_AR_ctl01_CAR_MainArticleRow" valign="top">
    // <tr id="ctl\d*_MC_.R_ctl\d*_CAR_MainArticleRow[\s\S]*?</table>[\s\S]*?</tr>
    NSString* articleMatchingPattern = @"<tr id=\"ctl\\d*_MC_.R_ctl\\d*_CAR_MainArticleRow[\\s\\S]*?</table>[\\s\\S]*?</tr>";
    NSArray *matches = [self matchesForPattern: articleMatchingPattern inText:page];
    
    NSMutableArray* articleArray = [[NSMutableArray alloc] initWithCapacity:matches.count];
    //NSMutableArray* blogArray = [[NSMutableArray alloc] initWithCapacity:matches.count];
    memberArticlesToFill.ArticleList = articleArray;
    //memberToFill.BlogList = blogArray;
    
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
        
        [articleArray addObject:article];
        
        //if(article.IsArticle)
        //    [articleArray addObject:article];
        //else
        //    [blogArray addObject:article];
        
    }
}


-(void)fillLogo:(UIImage**)logo fromPage:(NSString*) page
{
    // <img id="ctl00_MC_Prof_MemberImage" class="padded-top" src="/script/Membership/Images/member_unknown.gif"
    // <img id="ctl\d*_MC_Prof_MemberImage[\s\S]*?src="([\s\S]*?)"
    
    // <<img id="ctl00_Logo" tabindex="1" title="CodeProject" src="//dj9okeyxktdvd.cloudfront.net/App_Themes/CodeProject/Img/Birthday/logo250x135.gif" alt="Home" style="height:135px;width:250px;border-width:0px;">
    // <img id="ctl\d*_Logo[\s\S]*?src="([\s\S]*?)"
    NSString* imageUrlMatchingPattern = @"<img id=\"ctl\\d*_Logo[\\s\\S]*?src=\"([\\s\\S]*?)\"";
    NSString* imageUrl = [self captureForPattern: imageUrlMatchingPattern inText:page];
    NSString* imageFormattedUrl = [NSString stringWithFormat:@"http:%@", imageUrl];

    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageFormattedUrl]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];

    *logo = image;
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
    NSString *captureString = NULL;
    NSArray *matches = [self matchesForPattern: pattern inText:text];
    if(matches.count != 0)
    {
        NSTextCheckingResult* firstMatch = [matches firstObject];
        NSRange matchRange = [firstMatch rangeAtIndex:1];
        captureString = [text substringWithRange:matchRange];
    }
    
    return captureString;
}

- (NSString*)captureForPattern:(NSString*)pattern atIndex:(int)index inText:(NSString*)text {
    NSString *captureString = NULL;
    NSArray *matches = [self matchesForPattern: pattern inText:text];
    if(matches.count != 0)
    {
        NSTextCheckingResult* aMatch = [matches firstObject];
        if(index < aMatch.numberOfRanges) {
            NSRange matchRange = [aMatch rangeAtIndex:index];
            captureString = [text substringWithRange:matchRange];
        }
    }
    
    return captureString;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(connection == profilePageConnection)
        [profilePageData appendData:data];
    
    if(connection == articlePageConnection)
        [articlePageData appendData:data];
    
    //if(connection == homePageConnection)
    //    [homePageData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if(connection == profilePageConnection)
    {
        NSString *profilePage = [[NSString alloc]initWithData:profilePageData encoding:NSASCIIStringEncoding];
        
        [self fillMemberProfile:memberToFill fromProfilePage:profilePage];
        
        self.ProfilePageLoaded = true;
        
        if(progressDelegate != NULL)
            [progressDelegate codeprojectMemberProfileAvailable];
    }
    
    if(connection == articlePageConnection)
    {
        NSString *articlePage = [[NSString alloc]initWithData:articlePageData encoding:NSASCIIStringEncoding];
        
        if(memberToFill != NULL)
            [self fillMemberProfile:memberToFill fromArticlePage:articlePage];
        
        if(memberArticlesToFill != NULL)
           [self fillMemberArticles:memberArticlesToFill fromPage:articlePage];
        
        self.ArticlePageLoaded = true;
        
        if(progressDelegate != NULL)
            [progressDelegate codeprojectMemberArticleAvailable];
    }
    
    //if(connection == homePageConnection)
    //{
    //    NSString *homePage = [[NSString alloc]initWithData:homePageData encoding:NSASCIIStringEncoding];
    //
    //    if(logoToFill != NULL)
    //        [self fillLogo:logoToFill fromPage:homePage];
    //
    //    if(progressDelegate != NULL)
    //        [progressDelegate codeprojectLogoAvailable];
    //}

    
    if(self.ProfilePageLoaded && self.ArticlePageLoaded)
    {
        if(progressDelegate != NULL)
            [progressDelegate codeprojectMemberAvailable];
    }
}

@end
