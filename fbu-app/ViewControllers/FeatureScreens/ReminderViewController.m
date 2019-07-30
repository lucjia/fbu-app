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
    self.receivedReminderArrayDates = [[NSMutableArray alloc] init];
    self.receivedReminderArrayNoDates = [[NSMutableArray alloc] init];
    self.receivedReminderArrayTotal = [[NSMutableArray alloc] init];
    
    [self fetchReminders];
    
    // Refresh control for "pull to refresh"
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchReminders) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) fetchReminders {
    PFQuery *queryWithDate = [PFQuery queryWithClassName:@"Reminder"];
    
    [queryWithDate includeKey:@"reminderSender"];
    [queryWithDate includeKey:@"reminderReceiver"];
    [queryWithDate includeKey:@"reminderText"];
    [queryWithDate includeKey:@"reminderDueDate"];
    
    // soonest reminder Due Dates are first
    [queryWithDate whereKeyExists:@"reminderDueDate"];
    [queryWithDate orderByAscending:@"reminderDueDate"];
    
    // query for reminders that are assigned to the current user
    [queryWithDate whereKey:@"reminderReceiver" equalTo:[PFUser currentUser][@"persona"]];
    [queryWithDate findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
        if (reminders != nil) {
            self.receivedReminderArrayDates = reminders;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    // QUERY WITHOUT DATE (cannot do order by on compound queries)
    PFQuery *queryWithoutDate = [PFQuery queryWithClassName:@"Reminder"];
    
    [queryWithoutDate includeKey:@"reminderSender"];
    [queryWithoutDate includeKey:@"reminderReceiver"];
    [queryWithoutDate includeKey:@"reminderText"];
    
    // Order reminders w/o a due date by their created date
    [queryWithoutDate whereKeyDoesNotExist:@"reminderDueDate"];
    [queryWithoutDate orderByAscending:@"createdAt"];
    
    // query for reminders that are assigned to the current user
    [queryWithoutDate whereKey:@"reminderReceiver" equalTo:[PFUser currentUser][@"persona"]];
    [queryWithoutDate findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
        if (reminders != nil) {
            self.receivedReminderArrayNoDates = reminders;
            self.receivedReminderArrayTotal = [self.receivedReminderArrayDates arrayByAddingObjectsFromArray:self.receivedReminderArrayNoDates];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell" forIndexPath:indexPath];
    Reminder *currReminder = [self.receivedReminderArrayTotal objectAtIndex:indexPath.row];
    [cell updateReminderCellWithReminder:currReminder];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.receivedReminderArrayTotal count];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue to detail view, can't change the reminder, maybe add interactive elements
    if ([[segue identifier] isEqualToString:@"toReminderDetail"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Reminder *currentReminder = self.receivedReminderArrayTotal[indexPath.row];
        
        ReminderDetailViewController *reminderDetailVC = [segue destinationViewController];
        reminderDetailVC.reminder = currentReminder;
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
