//
//  SDERSSFeed.m
//  iCPVanity
//
//  Created by serge desmedt on 9/02/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDERSSFeed.h"
#import "SDERSSItem.h"
#import "GTMNSString+HTML.h"

@interface SDERSSFeed ()
{
    NSURL* url;
    
    NSXMLParser *parser;
    
    SDERSSItem* item;
    
    NSString* element;
    
    NSMutableArray* result;
    
    NSMutableString* title;
    NSMutableString* description;
    NSMutableString* link;
    NSMutableString* author;
    NSMutableString* pubDate;
}

@end

@implementation SDERSSFeed

- (id) initWithContentsOfURL: (NSURL*) feedUrl
{
    self = [super init];
    if (self) {
        url = feedUrl;
    }
    return(self);
}


- (void) loadRSS
{
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"])
    {
        
        item = [[SDERSSItem alloc] init];
        title = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
        author = [[NSMutableString alloc] init];
        pubDate = [[NSMutableString alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"])
    {
        
        item.Title = title;
        
        // Remove html tags from tekst
        NSRange r;
        while ((r = [description rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            [description setString:[description stringByReplacingCharactersInRange:r withString:@""]];

        // Expand any character references
        item.Description = [description gtm_stringByUnescapingFromHTML];
        
        item.Link = link;
        item.Author = author;
        item.Date = pubDate;
        
        if(result == nil)
        {
            result = [[NSMutableArray alloc] init];
        }
        [result addObject:item];
        
    }
    else if([elementName isEqualToString:@"title"] && [element isEqualToString:@"title"])
    {
        element = @"";
    }
    else if([elementName isEqualToString:@"description"] && [element isEqualToString:@"description"])
    {
        element = @"";
    }
    else if([elementName isEqualToString:@"link"] && [element isEqualToString:@"link"])
    {
        element = @"";
    }
    else if([elementName isEqualToString:@"author"] && [element isEqualToString:@"author"])
    {
        element = @"";
    }
    else if([elementName isEqualToString:@"pubDate"] && [element isEqualToString:@"pubDate"])
    {
        element = @"";
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"])
    {
        [title appendString:string];
    }
    else if ([element isEqualToString:@"description"])
    {
        [description appendString:string];
    }
    else if ([element isEqualToString:@"link"])
    {
        [link appendString:string];
    }
    else if ([element isEqualToString:@"author"])
    {
        [author appendString:string];
    }
    else if ([element isEqualToString:@"pubDate"])
    {
        [pubDate appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.Items = [[NSArray alloc] initWithArray:result];
    
    if(self.delegate != NULL)
        [self.delegate feedLoaded];
}

@end
