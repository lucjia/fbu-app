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
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>

@interface LeftViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.titlesArray = @[@"Create a House",
                         @"Settings"];
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
    if (indexPath.row == [self.titlesArray indexOfObject:@"Create a House"]) {
        // segue to Create a household view controller
        
    // Settings
    } else if (indexPath.row == [self.titlesArray indexOfObject:@"Settings"]) {
        SettingsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
        //viewController.view.backgroundColor = [UIColor whiteColor];
        
        UITabBarController *tabBarController = (UITabBarController *)mainViewController.rootViewController;
        UINavigationController *currentController = tabBarController.selectedViewController;
        
        [currentController pushViewController:viewController animated:YES];
    }

    [mainViewController hideLeftViewAnimated:YES delay:0.0 completionHandler:nil];
    // have to segue for each individual row
}

@end