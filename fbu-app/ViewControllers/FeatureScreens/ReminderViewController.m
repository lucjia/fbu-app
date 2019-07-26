//
//  ReminderViewController.m
//  fbu-app
//
//  Created by lucjia on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "ReminderViewController.h"
#import "ReminderCell.h"
#import "CustomButton.h"

@interface ReminderViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) NSInteger totalRowCount;

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.searchBar.delegate = self;
    
    self.totalRowCount = 4;
    self.receivedReminderArray = [[NSMutableArray alloc] init];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell" forIndexPath:indexPath];
    if (indexPath.row == self.totalRowCount - 1) {
        CustomButton *button = [[CustomButton alloc] init];
        UIButton *createReminderButton = [button styledBackgroundButtonWithOrigin:CGPointMake(20, 20) text:@"Create Reminder"];
        [createReminderButton addTarget:self action:@selector(segueToCompose) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:createReminderButton];
    } else {
        [cell updateReminderCell];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.totalRowCount = 4;
    return self.totalRowCount;
}

- (void) segueToCompose {
    [self performSegueWithIdentifier:@"toCompose" sender:self];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
