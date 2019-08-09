//
//  PostSearchLeftViewController.m
//  fbu-app
//
//  Created by jordan487 on 8/4/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "PostSearchLeftViewController.h"
#import "LeftViewCell.h"
#import "MainViewController.h"
#import "SettingsViewController.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "LogInViewController.h"

@interface PostSearchLeftViewController ()
{
    NSArray *titlesArray;
}


@end

@implementation PostSearchLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    titlesArray = @[@" ",
                    @"Roommate Finder",
                    @"Settings",
                    @" ",
                    @" ",
                    @" ",
                    @" ",
                    @" ",
                    @" ",
                    @" ",
                    @" ",
                    @" ",
                    @"Log Out"];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titlesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftViewCell" forIndexPath:indexPath];
    
    [cell updatePostSearchProperties:titlesArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    
    // back to main timeline
    if (indexPath.row == [titlesArray indexOfObject:@"Roommate Finder"]) {
        UIStoryboard *postSearch = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LGSideMenuController *sideMenuController = [postSearch instantiateViewControllerWithIdentifier:@"SearchingSideMenuController"];
        
        UITabBarController *rootView = (UITabBarController *)sideMenuController.rootViewController;
        
        UITabBarController *tabBarController = (UITabBarController *)mainViewController.rootViewController;
        UINavigationController *currentController = tabBarController.selectedViewController;
        
        [rootView setSelectedIndex:0];
        [currentController presentViewController:sideMenuController animated:YES completion:nil];
        
    // settings
    } else if (indexPath.row == [titlesArray indexOfObject:@"Settings"]) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SettingsViewController *viewController = [main instantiateViewControllerWithIdentifier:@"SettingsVC"];
        
        UITabBarController *tabBarController = (UITabBarController *)mainViewController.rootViewController;
        UINavigationController *currentController = tabBarController.selectedViewController;
        
        [currentController pushViewController:viewController animated:YES];
    } else if (indexPath.row == [titlesArray indexOfObject:@"Log Out"]) {
        [PFUser logOutInBackground];
        
        // Set root view controller to be log in screen
        LogInViewController *logInVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogInViewController"];
        [self presentViewController:logInVC animated:YES completion:nil];
    }
    
    [mainViewController hideLeftViewAnimated:YES delay:0.0 completionHandler:nil];
    // have to segue for each individual row
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}
@end
