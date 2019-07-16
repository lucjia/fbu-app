//
//  ViewController.m
//  fbu-app
//
//  Created by lucjia on 7/15/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "TimelineViewController.h"
#import <Parse/Parse.h>

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *userArrray;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
}


- (void) fetchUserTimeline {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"username"];
    [query includeKey:@"createdAt"];
    [query includeKey:@"profilePicture"];
//    [query includeKey:@"likeCount"];
//    [query includeKey:@"bio"];
    
    //[query whereKey:@"likesCount" greaterThan:@0];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.userArrray = posts;
            NSLog(@"COUNT: %lu", posts.count);
            //[self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)initViewController {
    UIViewController * timelineViewController = [[UIViewController alloc] init];
    [self presentViewController:timelineViewController animated:YES completion:nil];
}

- (void)initTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor blueColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.tableView];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    static NSString *cellIdentifier = @"RoommateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.userArrray.count;
}


@end
