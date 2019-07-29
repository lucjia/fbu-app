//
//  ReminderViewController.m
//  fbu-app
//
//  Created by lucjia on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "ReminderViewController.h"
#import "ReminderCell.h"
#import "Reminder.h"
#import "ReminderDetailViewController.h"
#import "CustomButton.h"
#import "Parse/Parse.h"

@interface ReminderViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.searchBar.delegate = self;
    self.receivedReminderArray = [[NSMutableArray alloc] init];
    
    [self fetchReminders];
    
    // Refresh control for "pull to refresh"
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchReminders) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) fetchReminders {
    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
    [query includeKey:@"reminderSender"];
    [query includeKey:@"reminderReceiver"];
    [query includeKey:@"reminderText"];
    [query includeKey:@"reminderDueDate"];
    
    [query whereKey:@"reminderReceiver" equalTo:[PFUser currentUser][@"persona"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
        if (reminders != nil) {
            self.receivedReminderArray = reminders;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell" forIndexPath:indexPath];
    Reminder *currReminder = [self.receivedReminderArray objectAtIndex:indexPath.row];
    [cell updateReminderCellWithReminder:currReminder];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.receivedReminderArray count];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue to detail view, can't change the reminder, maybe add interactive elements
    if ([[segue identifier] isEqualToString:@"toReminderDetail"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Reminder *currentReminder = self.receivedReminderArray[indexPath.row];
        
        ReminderDetailViewController *reminderDetailVC = [segue destinationViewController];
        reminderDetailVC.reminder = currentReminder;
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
