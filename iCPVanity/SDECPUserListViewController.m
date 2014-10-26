//
//  SDEUserListViewController.m
//  iCPVanity
//
//  Created by serge desmedt on 24/10/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECPUserListViewController.h"
#import "SDECodeProjectMemberDatabase.h"
#import "SDECodeProjectMember.h"
#import "SDECPUserProfileViewController.h"

@interface SDECPUserListViewController ()
{
    NSArray* memberList;
    NSArray* searchResults;
    
    NSString* filterString;
}
@end

@implementation SDECPUserListViewController

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
    
    SDECodeProjectMemberDatabase* memberDatabase = [[SDECodeProjectMemberDatabase alloc] init];
    
    memberList = [memberDatabase getMemberList];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        return memberList.count;
    }
}

- (GLfloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
            member = [searchResults objectAtIndex:indexPath.row];
            
            cell = [self.MemberListTableView dequeueReusableCellWithIdentifier:MemberCellIdentifier];
        }
    } else {
        cell = [self.MemberListTableView dequeueReusableCellWithIdentifier:MemberCellIdentifier];
        member = [memberList objectAtIndex:indexPath.row];
    }
    
    static NSInteger titleTag = 100;
    
    ((UILabel*)[cell viewWithTag:titleTag]).text = member.MemberName;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    NSMutableArray* filteredMemberList = [[NSMutableArray alloc] init];
    filterString = searchString;
    
//    SDECodeProjectMember* member1 = [[SDECodeProjectMember alloc] init];
//    member1.MemberName = @"Ikke gefilterd";
//    [filteredMemberList addObject:member1];
    
    if(memberList.count != 0) {
        
    }

    searchResults = [[NSArray alloc] initWithArray:filteredMemberList];
    
    return YES;
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowMember"]) {
        self.searchDisplayController.searchBar.text = @"";
        [self.searchDisplayController.searchBar resignFirstResponder];
        self.searchDisplayController.active = FALSE;
        
    }
    else if ([segue.identifier isEqualToString:@"LoadMember"]){
        self.searchDisplayController.searchBar.text = @"";
        [self.searchDisplayController.searchBar resignFirstResponder];
        self.searchDisplayController.active = FALSE;
        
    }
    
    ((SDECPUserProfileViewController*)segue.destinationViewController).CodeprojectMemberId = [filterString integerValue];

}


@end
