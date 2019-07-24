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
#import "DetailsViewController.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource, RoommateCellDelegate>

@property (strong, nonatomic) NSArray *userArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchUserTimeline];
}


- (void) fetchUserTimeline {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Persona"];
    
    [query includeKey:@"persona"];
    [query includeKey:@"geoPoint"];
    
    Persona *persona = [PFUser currentUser][@"persona"];
    [persona fetchIfNeeded];
    // query excludes current user
    [query whereKey:@"objectId" notEqualTo:persona.objectId];
    
    PFGeoPoint *userGeoPoint = [persona objectForKey:@"geoPoint"];
    // limit to users that are near current user
    [query whereKey:@"geoPoint" nearGeoPoint:userGeoPoint withinMiles:12.0];
    
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
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
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
    
    Persona *user = self.userArray[indexPath.row];
    
    [cell updateProperties:user];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.userArray.count;
}

- (IBAction)didPressLogOut:(id)sender {
    [PFUser logOutInBackground];
    
    // Set root view controller to be log in screen
    LogInViewController *logInVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogInViewController"];
    [self presentViewController:logInVC animated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"timelineToDetailsSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        PFUser *user = self.userArray[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.user = user;
    } else {
        // do nothing
    }
}

@end
