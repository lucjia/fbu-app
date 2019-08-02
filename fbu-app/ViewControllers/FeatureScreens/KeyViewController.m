//
//  KeyViewController.m
//  fbu-app
//
//  Created by lucjia on 8/1/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "KeyViewController.h"
#import "ProgressViewController.h"
#import "KeyCell.h"

@interface KeyViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *keyLabels;
    NSArray *emoji;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.clipsToBounds = true;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner | kCALayerMinXMaxYCorner;
    
    emoji = [[NSArray alloc] initWithObjects:@"🍃", @"🌱", @"🌿", @"🌷", @"🌹", @"🐛", @"🐝", nil];
    keyLabels = [[NSArray alloc] initWithObjects:@"< 5 reminders completed", @"5 reminders completed", @"10 reminders completed", @"15 reminders completed", @"20 reminders completed", @"Overdue reminders", @"No overdue reminders", nil];
}

- (IBAction)didTap:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    KeyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KeyCell" forIndexPath:indexPath];
    cell.emojiLabel.text = [emoji objectAtIndex:indexPath.row];
    cell.label.text = [keyLabels objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [keyLabels count];
}

// Header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:20]];
    label.text = @"Key";
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]];
    
    // round top two corners
    view.clipsToBounds = true;
    view.layer.cornerRadius = 10;
    view.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

@end
