//
//  ViewController.m
//  fbu-app
//
//  Created by lucjia on 7/15/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "TimelineViewController.h"
#import <Parse/Parse.h>
#import "RoommateCell.h"
#import "DetailsViewController.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *userArrray;
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
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"username"];
    [query includeKey:@"createdAt"];
    
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            // do something with the array of object returned by the call
            self.userArrray = users;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RoommateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomateCell"];
    
    PFUser *user = self.userArrray[indexPath.row];
    
    [cell updateProperties:user];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.userArrray.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"timelineToDetailsSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        PFUser *user = self.userArrray[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.user = user;
    } else {
        // do nothing
    }
}

@end
