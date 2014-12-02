//
//  SDEUserListViewController.m
//  iCPVanity
//
//  Created by serge desmedt on 24/10/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECPUserListViewController.h"
#import "SDECodeProjectMemberStore.h"
#import "SDECodeProjectMember.h"
#import "SDECPUserProfileViewController.h"
#import "SDECodeProjectMemberStore.h"

@interface SDECPUserListViewController ()
{
    NSArray* searchResults;
    
    NSString* filterString;
}

//@property (strong) NSMutableArray* memberList;
@property (strong) NSArray* memberList;

@end

@implementation SDECPUserListViewController


- (IBAction) refreshMembers
{
    [self refreshMember:0];
}

- (void) refreshMember:(int)memberIndex
{
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    SDECodeProjectMemberStore* memberStore = [[SDECodeProjectMemberStore alloc] init];
    self.memberList = [memberStore getAllMembers];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSInteger extraEntry = 0;
        
        NSScanner *scanner = [NSScanner scannerWithString:filterString];
        BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
        if(isNumeric) {
            // add one for the add member entry
            extraEntry = 1;
        }
        
        return searchResults.count + extraEntry;
    } else {
        NSUInteger memberCount =self.memberList.count;
        return memberCount;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView && indexPath.row == 0) {
        return 35;
    }
    
    // changing this will also require changement in the storyboard and vice versa
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MemberCellIdentifier = @"MemberCell";
    static NSString *AddMemberCellIdentifier = @"AddMemberCell";
    UITableViewCell *cell = nil;
    
    SDECodeProjectMember* member = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSScanner *scanner = [NSScanner scannerWithString:filterString];
        BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
        
        if(indexPath.row == 0 && isNumeric) {
            static NSInteger textTag = 200;
            
            cell = [self.MemberListTableView dequeueReusableCellWithIdentifier:AddMemberCellIdentifier];
            
            ((UILabel*)[cell viewWithTag:textTag]).text = [NSString stringWithFormat:@"Load member %@", self->filterString];

            return cell;
        }
        else {
            member = [searchResults objectAtIndex:(indexPath.row - (isNumeric?1:0))];
            
            cell = [self.MemberListTableView dequeueReusableCellWithIdentifier:MemberCellIdentifier];
        }
    } else {
        cell = [self.MemberListTableView dequeueReusableCellWithIdentifier:MemberCellIdentifier];
        member = [self.memberList objectAtIndex:indexPath.row];
    }
    
    static NSInteger memberNameTag = 100;
    static NSInteger memberPostsCountTag = 101;
    static NSInteger memberReputationTag = 102;
    static NSInteger memberGravatarTag = 105;
    
    ((UILabel*)[cell viewWithTag:memberNameTag]).text = member.MemberName;
    ((UILabel*)[cell viewWithTag:memberPostsCountTag]).text = [NSString stringWithFormat:@"Posts: %d", (member.ArticleCount + member.BlogCount)];
    ((UILabel*)[cell viewWithTag:memberReputationTag]).text = member.Reputation;
    
    UIImage* gravatar = [SDECodeProjectMemberStore getMemberGravatar:member];
    ((UIImageView*)[cell viewWithTag:memberGravatarTag]).image = gravatar;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support conditional editing of the table view.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return UITableViewCellEditingStyleDelete;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        SDECodeProjectMember* member = [self.memberList objectAtIndex:indexPath.row];
        
        SDECodeProjectMemberStore* memberStore = [[SDECodeProjectMemberStore alloc] init];
        [memberStore deleteMember:member.MemberId];
        
        self.memberList = [memberStore getAllMembers];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    filterString = searchString;
    int filterId = [filterString integerValue];
    
    if(self.memberList.count != 0) {
        NSArray* filteredMemberList = [self.memberList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"MemberName beginswith %@ OR MemberId == %i", filterString, filterId]];
        
        searchResults = [[NSArray alloc] initWithArray:filteredMemberList];
        
    }
    
    return YES;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    int memberId = -1;
    if ([segue.identifier isEqualToString:@"ShowMember"]) {
        SDECodeProjectMember* selectedMember = NULL;
        int offset = 0;
        if (self.searchDisplayController.active == TRUE) {
            NSScanner *scanner = [NSScanner scannerWithString:filterString];
            BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
            
            offset = isNumeric?1:0;
            
            NSIndexPath* selectedEntry = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            selectedMember = [searchResults objectAtIndex:(selectedEntry.row - offset)];
            
            // show the data of an existing member
            self.searchDisplayController.searchBar.text = @"";
            [self.searchDisplayController.searchBar resignFirstResponder];
            self.searchDisplayController.active = FALSE;
        }
        else {
            NSIndexPath* selectedEntry = [self.MemberListTableView indexPathForSelectedRow];
            selectedMember = [self.memberList objectAtIndex:(selectedEntry.row - offset)];
        }
        memberId = selectedMember.MemberId;
        
    }
    else if ([segue.identifier isEqualToString:@"LoadMember"]){
        
        memberId = [filterString integerValue];
        
        // load the data of a new member
        self.searchDisplayController.searchBar.text = @"";
        [self.searchDisplayController.searchBar resignFirstResponder];
        self.searchDisplayController.active = FALSE;
        
    }
    
    ((SDECPUserProfileViewController*)segue.destinationViewController).CodeprojectMemberId = memberId;

}


@end
