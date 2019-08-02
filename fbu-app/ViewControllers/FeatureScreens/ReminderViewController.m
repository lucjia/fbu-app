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
#import "ProgressViewController.h"
#import "Parse/Parse.h"

@interface ReminderViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    // different way of declaring property
    NSMutableArray *filteredResults;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

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
    
    self.segmentedControl.selectedSegmentIndex = self.segmentIndex;
    
    [self fetchReminders];
    
    // Refresh control for "pull to refresh"
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchReminders) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search for a reminder...";
}

- (void) fetchReminders {
    if (self.segmentIndex == 0) {
        [self fetchReceivedReminders];
    } else if (self.segmentIndex == 1) {
        [self fetchSentReminders];
    } else if (self.segmentIndex == 2) {
        // segue to another view controller to see progress
        ProgressViewController *progressVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProgressVC"];
        [self presentViewController:progressVC animated:YES completion:nil];
    }
}

- (void) fetchReceivedReminders {
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
            self.receivedReminderArrayDates = (NSMutableArray *)reminders;
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
            self.receivedReminderArrayNoDates = (NSMutableArray *)reminders;
            self.receivedReminderArrayTotal = (NSMutableArray *)[self.receivedReminderArrayDates arrayByAddingObjectsFromArray:self.receivedReminderArrayNoDates];
            filteredResults = self.receivedReminderArrayTotal;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}

- (void) fetchSentReminders {
    PFQuery *queryWithDate = [PFQuery queryWithClassName:@"Reminder"];
    
    [queryWithDate includeKey:@"reminderSender"];
    [queryWithDate includeKey:@"reminderReceiver"];
    [queryWithDate includeKey:@"reminderText"];
    [queryWithDate includeKey:@"reminderDueDate"];
    
    // soonest reminder Due Dates are first
    [queryWithDate whereKeyExists:@"reminderDueDate"];
    [queryWithDate orderByAscending:@"reminderDueDate"];
    
    // query for reminders that are assigned to the current user
    [queryWithDate whereKey:@"reminderSender" equalTo:[PFUser currentUser][@"persona"]];
    [queryWithDate findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
        if (reminders != nil) {
            self.receivedReminderArrayDates = (NSMutableArray *)reminders;
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
    [queryWithoutDate whereKey:@"reminderSender" equalTo:[PFUser currentUser][@"persona"]];
    [queryWithoutDate findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
        if (reminders != nil) {
            self.receivedReminderArrayNoDates = (NSMutableArray *)reminders;
            self.receivedReminderArrayTotal = (NSMutableArray *)[self.receivedReminderArrayDates arrayByAddingObjectsFromArray:self.receivedReminderArrayNoDates];
            filteredResults = self.receivedReminderArrayTotal;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}

- (IBAction)segmentedControlTapped:(id)sender {
    self.segmentIndex = self.segmentedControl.selectedSegmentIndex;
    [self fetchReminders];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell" forIndexPath:indexPath];
    if (self.segmentIndex == 0) {
        cell.received = YES;
    } else {
        cell.received = NO;
    }
    Reminder *currReminder = [filteredResults objectAtIndex:indexPath.row];
    [cell updateReminderCellWithReminder:currReminder];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [filteredResults count];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue to detail view, can't change the reminder, maybe add interactive elements
    if ([[segue identifier] isEqualToString:@"toReminderDetail"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Reminder *currentReminder = filteredResults[indexPath.row];
        
        ReminderDetailViewController *reminderDetailVC = [segue destinationViewController];
        reminderDetailVC.reminder = currentReminder;
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

// Search through reminders based on keywords / sender
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // Check if search contains s: or S: (for sender)
    // If so, search through roommate
    if (searchText.length != 0 && ([searchText containsString:@"R:"] || [searchText containsString:@"r:"])) {
        if ([searchText length] > 2) {
            NSString *newSearchText = [[NSString alloc] init];
            newSearchText = [searchText substringFromIndex:2];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.reminderSender.firstName contains[cd] %@", newSearchText];
            filteredResults = (NSMutableArray *)[self.receivedReminderArrayTotal filteredArrayUsingPredicate:predicate];
        }
    // If not, search through the reminder text
    } else if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.reminderText contains[cd] %@", searchText];
        filteredResults = (NSMutableArray *)[self.receivedReminderArrayTotal filteredArrayUsingPredicate:predicate];
    } else {
        filteredResults = (NSMutableArray *)self.receivedReminderArrayTotal;
    }
    [self.tableView reloadData];
    [self scrollToTopAfterSearch];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.searchBar.showsCancelButton = YES;
    [self.tableView reloadData];
    [self scrollToTopAfterSearch];
    return true;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    filteredResults = self.receivedReminderArrayTotal;
    [self.tableView reloadData];
    [self scrollToTopAfterSearch];
}

- (void) scrollToTopAfterSearch {
    [self.tableView layoutIfNeeded];
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
}

// Swipe to delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from Parse
        Reminder *swipedReminder = [filteredResults objectAtIndex:indexPath.row];
        [swipedReminder deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error != nil) {
                [self.tableView reloadData];
            }
        }];
    }
}

@end
