//
//  SDECodeProjectMemberStore.m
//  iCPVanity
//
//  Created by serge desmedt on 8/11/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECodeProjectMemberStore.h"
#import "SDECodeProjectMember.h"

@implementation SDECodeProjectMemberStore

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self->managedObjectContext = [self getManagedObjectContext];
    }
    
    return self;
}

- (NSArray*) getAllMembers
{
    NSMutableArray* storeMemberList;
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"CodeProjectMember" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    storeMemberList = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

    NSMutableArray* memberList = [[NSMutableArray alloc] initWithCapacity:storeMemberList.count];
    for(int i=0; i < storeMemberList.count; i++)
    {
        SDECodeProjectMember* member = [[SDECodeProjectMember alloc] initWithManagedObject:storeMemberList[i]];
        [memberList addObject:member];
    }
    
    return memberList;
}


- (NSManagedObject*) getMemberAsManagedObject:(int)memberId
{
    NSMutableArray* storeMemberList;
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"CodeProjectMember" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %i", memberId];
    [fetchRequest setPredicate:predicate];
    
    storeMemberList = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSManagedObject* moMember = NULL;
    if(storeMemberList != NULL && storeMemberList.count > 0)
    {
        moMember = storeMemberList[0];
    }
    
    return moMember;
}

+ (UIImage*) getMemberGravatar:(SDECodeProjectMember*) member
{
    NSString* imagePath = [self getMemberGravatarPath:member];

    UIImage *gravatar = [UIImage imageWithContentsOfFile:imagePath];
    member.Gravatar = gravatar;
    
    return gravatar;
}

//- (SDECodeProjectMember*) getMember:(int)memberId
//{
//    NSManagedObject* moMember = [self getMemberAsManagedObject:memberId];
//    SDECodeProjectMember* member = NULL;
//    if(moMember != NULL)
//    {
//        member = [[SDECodeProjectMember alloc] initWithManagedObject:moMember];
//    }
//
//    return member;
//}

- (void) saveMember:(SDECodeProjectMember*) member
{
    NSManagedObject* moMember = [self getMemberAsManagedObject:member.MemberId];
    if (moMember == NULL) {
        moMember = [NSEntityDescription insertNewObjectForEntityForName:@"CodeProjectMember" inManagedObjectContext:managedObjectContext];
    }
    [self fillManagedObject:moMember fromMember: member];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    if(member.Gravatar != NULL) {
        
        NSData *imageData = UIImagePNGRepresentation(member.Gravatar);
       
        NSString* imagePath = [SDECodeProjectMemberStore getMemberGravatarPath:member];
        
        NSLog((@"pre writing to file"));
        if (![imageData writeToFile:imagePath atomically:NO])
        {
            NSLog(@"Failed to cache image data to disk");
        }
        else
        {
            NSLog(@"the cachedImagedPath is %@",imagePath);
        }

    }
    
}

- (void) deleteMember:(int) memberId
{
    NSManagedObject* moMember = [self getMemberAsManagedObject:memberId];
    if (moMember == NULL) {
        return;
    }
    
    NSError * error = nil;
    [managedObjectContext deleteObject:moMember];
    [managedObjectContext save:&error];
}

+ (NSString*) getMemberGravatarPath:(SDECodeProjectMember*) member
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",member.MemberId]];

    return imagePath;
}

- (void) fillManagedObject:(NSManagedObject*)mo fromMember:(SDECodeProjectMember*) member
{
    [mo setValue:[NSNumber numberWithInt:member.MemberId] forKey:@"id"];
    [mo setValue:member.MemberName forKey:@"name"];
    [mo setValue:member.Reputation forKey:@"reputation"];
    [mo setValue:[NSNumber numberWithInt:member.ArticleCount] forKey:@"article_count"];
    [mo setValue:[NSNumber numberWithInt:member.BlogCount] forKey:@"blog_count"];
}

- (NSManagedObjectContext *)getManagedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
