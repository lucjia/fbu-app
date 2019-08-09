//
//  TimelineViewController.m
//  fbu-app
//
//  Created by lucjia on 7/15/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "TimelineViewController.h"
#import "LogInViewController.h"
#import <Parse/Parse.h>
#import "RoommateCell.h"
#import "User.h"
#import "House.h"
#import "Persona.h"
#import "CustomColor.h"
#import "DetailsViewController.h"
#import "SVProgressHUD.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource, RoommateCellDelegate>
{
    Persona *currentPersona;
}

@property (strong, nonatomic) NSArray *userArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    [SVProgressHUD show];
    
    currentPersona = [PFUser currentUser][@"persona"];
    [currentPersona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            [self fetchUserTimelineWithPersona:(Persona *)object];
        }
    }];
    
    // Refresh control for "pull to refresh"
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)refreshView {
    [self fetchUserTimelineWithPersona:currentPersona];
}

- (void) fetchUserTimelineWithPersona:(Persona *)persona {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Persona"];
    
    [query includeKey:@"persona"];
    [query includeKey:@"geoPoint"];
    
    
    // query excludes current user
    [query whereKey:@"username" notEqualTo:persona.username];
    
    
    PFGeoPoint *userGeoPoint = [persona objectForKey:@"geoPoint"];
    // limit to users that are near current user
    double radius;
    if ([[persona objectForKey:@"radius"] doubleValue]) {
        radius = [[persona objectForKey:@"radius"] doubleValue];
    } else {
        radius = 12.0;
    }
    [query whereKey:@"geoPoint" nearGeoPoint:userGeoPoint withinMiles:radius];
    
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"firstName"];
    [query includeKey:@"lastName"];
    [query includeKey:@"username"];
    [query includeKey:@"createdAt"];
    [query includeKey:@"location"];
    [query includeKey:@"persona"];
    [query includeKey:@"geoPoint"];
    
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            // do something with the array of object returned by the call
            self.userArray = users;
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)showAlertOnTimeline:(nonnull UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RoommateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomateCell"];
    cell.delegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    
    Persona *user = self.userArray[indexPath.row];
    
    [cell updateProperties:user];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.userArray.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"timelineToDetailsSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Persona *user = self.userArray[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.user = user;
    } else {
        // do nothing
    }
}
- (IBAction)didTapLeftMenu:(id)sender {
    [self showLeftViewAnimated:self];
}

@end
