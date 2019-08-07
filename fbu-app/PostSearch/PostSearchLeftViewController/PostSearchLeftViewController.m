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
    titlesArray = @[@"Back to roommate search",
                    @"⚙ Settings"];
    
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
    if (indexPath.row == [titlesArray indexOfObject:@"Back to roommate search"]) {
        UIStoryboard *postSearch = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LGSideMenuController *sideMenuController = [postSearch instantiateViewControllerWithIdentifier:@"SearchingSideMenuController"];
        
        UITabBarController *rootView = (UITabBarController *)sideMenuController.rootViewController;
        
        UITabBarController *tabBarController = (UITabBarController *)mainViewController.rootViewController;
        UINavigationController *currentController = tabBarController.selectedViewController;
        
        [rootView setSelectedIndex:0];
        [currentController presentViewController:sideMenuController animated:YES completion:nil];
        
    // settings
    } else if (indexPath.row == [titlesArray indexOfObject:@"⚙ Settings"]) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SettingsViewController *viewController = [main instantiateViewControllerWithIdentifier:@"SettingsVC"];
        
        UITabBarController *tabBarController = (UITabBarController *)mainViewController.rootViewController;
        UINavigationController *currentController = tabBarController.selectedViewController;
        
        [currentController pushViewController:viewController animated:YES];
    }
    
    [mainViewController hideLeftViewAnimated:YES delay:0.0 completionHandler:nil];
    // have to segue for each individual row
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}
@end
