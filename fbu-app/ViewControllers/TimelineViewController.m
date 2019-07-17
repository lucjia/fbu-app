//
//  TimelineViewController.m
//  fbu-app
//
//  Created by lucjia on 7/15/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "TimelineViewController.h"
#import <Parse/Parse.h>
#import "RoommateCell.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *userArrray;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchUserTimeline];
    [self initTableView];
    
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

// creates table view
- (void)initTableView {
    // full screen
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    // allows for reusable cells
    [self.tableView registerClass:[RoommateCell class] forCellReuseIdentifier:@"RoommateCell"];

    [self.view addSubview:self.tableView];
    
    }

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    static NSString *cellIdentifier = @"RoommateCell";
    RoommateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell = [[RoommateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    PFUser *user = self.userArrray[indexPath.row];
    
    [cell updateProperties:user];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.userArrray.count;
}


@end
