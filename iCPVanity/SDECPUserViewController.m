//
//  SDECPUserViewController.m
//  iCPVanity
//
//  Created by serge desmedt on 25/01/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDECPUserViewController.h"
#import "SDECPUserProfileViewController.h"
#import "SDECodeProjectUrlScheme.h"

@interface SDECPUserViewController ()

@end

@implementation SDECPUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserPageViewController"];
    self.pageViewController.dataSource = self;
    
    UIViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
	
    codeprojectMember = [[SDECodeProjectMember alloc] initWithId:15715 delegate:self];
    
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    SDEUserDataViewController* result = nil;
    // Create a new view controller and pass suitable data.
    if(index == 0)
    {
        SDECPUserProfileViewController* userProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
        result = userProfile;
    }
    if(index == 1)
    {
        result = [self.storyboard instantiateViewControllerWithIdentifier:@"UserArticlesViewController"];
    }
    if(index == 2)
    {
        result = [self.storyboard instantiateViewControllerWithIdentifier:@"UserReputationViewController"];
    }
    
    result.PageIndex = index;
    
    return (UIViewController *)result;
}


- (NSUInteger)indexOfViewController:(SDEUserDataViewController *)viewController
{
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return viewController.PageIndex;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(SDEUserDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(SDEUserDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == 3) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


- (void)codeprojectMemberProfileAvailable {
    


}


- (void)codeprojectMemberArticleAvailable {
    
    NSArray* children = [self.pageViewController childViewControllers];
    if(children.count != 1)
    {
        return;
    }
    
    SDEUserDataViewController *currentViewController = (SDEUserDataViewController *)[children firstObject];
    if(currentViewController.PageIndex == 0)
    {
        SDECPUserProfileViewController* userProfile = (SDECPUserProfileViewController*)currentViewController;
        userProfile.NameLabel.text = codeprojectMember.MemberName;
        userProfile.ReputationLabel.text = codeprojectMember.Reputation;
    }
    //_myLabel.text = codeprojectMember.MemberName;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
