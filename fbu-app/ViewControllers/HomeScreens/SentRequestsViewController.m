//
//  SentRequestsViewController.m
//  fbu-app
//
//  Created by jordan487 on 7/22/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "SentRequestsViewController.h"
#import <Parse/Parse.h>
#import "Request.h"
#import "SentRequestsCell.h"
#import "CustomColor.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>

@interface SentRequestsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UIRefreshControl *refreshControl;
}


@property (strong, nonatomic) NSMutableArray *receiversArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SentRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[CustomColor darkMainColor:1.0]}];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self fetchSentRequestTimeline];
    
    // Refresh control for "pull to refresh"
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    refreshControl.layer.zPosition = -1;
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void) fetchSentRequestTimeline {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Request"];
    [query whereKey:@"sender" equalTo:[PFUser currentUser][@"persona"]]; // requests sent by current user
    
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"sender"];
    [query includeKey:@"receiver"];
    
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *requests, NSError *error) {
        if (requests != nil) {
            // do something with the array of object returned by the call
            self.receiversArray = [NSMutableArray arrayWithArray:requests];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self->refreshControl endRefreshing];
    }];
}

- (void)refreshView {
    [self fetchSentRequestTimeline];
}

- (IBAction)didTapLeftMenu:(id)sender {
    [self showLeftViewAnimated:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SentRequestsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SentRequestsCell"];
    
    Request *request = self.receiversArray[indexPath.row];
    
    cell.backgroundColor = [UIColor whiteColor];
    [cell updateProperties:request];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.receiversArray.count;
}

@end
