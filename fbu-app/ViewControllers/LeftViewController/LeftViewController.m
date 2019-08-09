//
//  LeftViewController.m
//  fbu-app
//
//  Created by jordan487 on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftViewCell.h"
#import "MainViewController.h"
#import "TimelineViewController.h"
#import "SettingsViewController.h"
#import "RulesViewController.h"
#import "ReminderViewController.h"
#import "ProgressViewController.h"
#import "LogInViewController.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>


@interface LeftViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.titlesArray = @[@"🏠 Create a House",
                         @"📜 House Rules",
                         @"📌 Bulletin Board",
                         @"📅 Calendar",
                         @"📋 Reminders",
                         @"      📨 Sent Reminders",
                         @"      🌱 Progress",
                         @"Finances",
                         @"⚙ Settings",
                         @"Log Out"];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftViewCell" forIndexPath:indexPath];
    
    [cell updateProperties:self.titlesArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    
    // Create a House
    if (indexPath.row == [self.titlesArray indexOfObject:@"🏠 Create a House"]) {
        // segue to Create a household view controller
        SettingsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HousematesViewController"];
        
        UITabBarController *tabBarController = (UITabBarController *)mainViewController.rootViewController;
        UINavigationController *currentController = tabBarController.selectedViewController;
        
        [currentController pushViewController:viewController animated:YES];
        
    // Features (Separate storyboard)
    } else if (indexPath.row == [self.titlesArray indexOfObject:@"📌 Bulletin Board"]) {
        UIStoryboard *postSearch = [UIStoryboard storyboardWithName:@"PostSearch" bundle:nil];
        LGSideMenuController *sideMenuController = [postSearch instantiateViewControllerWithIdentifier:@"PostSearchSideMenuController"];
        
        UITabBarController *rootView = (UITabBarController *)sideMenuController.rootViewController;
        
        UITabBarController *tabBarController = (UITabBarController *)mainViewController.rootViewController;
        UINavigationController *currentController = tabBarController.selectedViewController;
        
        [rootView setSelectedIndex:0];
        [currentController presentViewController:sideMenuController animated:YES completion:nil];
        
    } else if (indexPath.row == [self.titlesArray indexOfObject:@"📅 Calendar"]) {
        UIStoryboard *postSearch = [UIStoryboard storyboardWithName:@"PostSearch" bundle:nil];
        LGSideMenuController *sideMenuController = [postSearch instantiateViewControllerWithIdentifier:@"PostSearchSideMenuController"];
        
        UITabBarController *rootView = (UITabBarController *)sideMenuController.rootViewController;
        
        UITabBarController *tabBarController = (UITabBarController *)mainViewController.rootViewController;
        UINavigationController *currentController = tabBarController.selectedViewController;
        
        [rootView setSelectedIndex:1];
        [currentController presentViewController:sideMenuController animated:YES completion:nil];
    
    } else if (indexPath.row == [self.titlesArray indexOfObject:@"📋 Reminders"]) {
        UIStoryboard *postSearch = [UIStoryboard storyboardWithName:@"PostSearch" bundle:nil];
        LGSideMenuController *sideMenuController = [postSearch instantiateViewControllerWithIdentifier:@"PostSearchSideMenuController"];
        
        UITabBarController *rootView = (UITabBarController *)sideMenuController.rootViewController;
        
        UITabBarController *tabBarController = (UITabBarController *)mainViewController.rootViewController;
        UINavigationController *currentController = tabBarController.selectedViewController;
        
        [rootView setSelectedIndex:2];
        [currentController presentViewController:sideMenuController animated:YES completion:nil];
        
    // Reminder Subfeatures
    } else if (indexPath.row == [self.titlesArray indexOfObject:@"      📨 Sent Reminders"]) {
        UIStoryboard *postSearch = [UIStoryboard storyboardWithName:@"PostSearch" bundle:nil];
        LGSideMenuController *sideMenuController = [postSearch instantiateViewControllerWithIdentifier:@"PostSearchSideMenuController"];
        
        UITabBarController *rootView = (UITabBarController *)sideMenuController.rootViewController;
        
        UITabBarController *tabBarController = (UITabBarController *)mainViewController.rootViewController;
        UINavigationController *currentController = tabBarController.selectedViewController;
        
        [rootView setSelectedIndex:2];
        
        UINavigationController *navController = rootView.selectedViewController;
        ReminderViewController *reminderController = (ReminderViewController *)navController.visibleViewController;
        reminderController.segmentIndex = 1;
        [currentController presentViewController:sideMenuController animated:YES completion:nil];
    
    } else if (indexPath.row == [self.titlesArray indexOfObject:@"Finances"]) {
        UIStoryboard *postSearch = [UIStoryboard storyboardWithName:@"PostSearch" bundle:nil];
        LGSideMenuController *sideMenuController = [postSearch instantiateViewControllerWithIdentifier:@"PostSearchSideMenuController"];
        
        UITabBarController *rootView = (UITabBarController *)sideMenuController.rootViewController;
        
        UITabBarController *tabBarController = (UITabBarController *)mainViewController.rootViewController;
        UINavigationController *currentController = tabBarController.selectedViewController;
        
        [rootView setSelectedIndex:3];
        [currentController presentViewController:sideMenuController animated:YES completion:nil];
    
    } else if (indexPath.row == [self.titlesArray indexOfObject:@"📜 House Rules"]) {
        UIStoryboard *postSearch = [UIStoryboard storyboardWithName:@"PostSearch" bundle:nil];
        // segue to another view controller to see progress
        UINavigationController *viewController = [postSearch instantiateViewControllerWithIdentifier:@"HouseRules"];
        [self presentViewController:viewController animated:YES completion:nil];
        
    } else if (indexPath.row == [self.titlesArray indexOfObject:@"      🌱 Progress"]) {
        UIStoryboard *postSearch = [UIStoryboard storyboardWithName:@"PostSearch" bundle:nil];
        // segue to another view controller to see progress
        ProgressViewController *progressVC = [postSearch instantiateViewControllerWithIdentifier:@"ProgressVC"];
        [self presentViewController:progressVC animated:YES completion:nil];
        
    // Settings
    } else if (indexPath.row == [self.titlesArray indexOfObject:@"⚙ Settings"]) {
        SettingsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
        
        UITabBarController *tabBarController = (UITabBarController *)mainViewController.rootViewController;
        UINavigationController *currentController = tabBarController.selectedViewController;
        
        [currentController pushViewController:viewController animated:YES];
    } else if (indexPath.row == [self.titlesArray indexOfObject:@"Log Out"]) {
        [PFUser logOutInBackground];
        
        // Set root view controller to be log in screen
        LogInViewController *logInVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogInViewController"];
        [self presentViewController:logInVC animated:YES completion:nil];
    }
    

    [mainViewController hideLeftViewAnimated:YES delay:0.0 completionHandler:nil];
    // have to segue for each individual row
}

@end
