//
//  RulesViewController.m
//  fbu-app
//
//  Created by sophiakaz on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "RulesViewController.h"
#import "Parse/Parse.h"
#import "House.h"
#import "RuleCell.h"

@interface RulesViewController () <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *rules;
@property (strong, nonatomic) House *house;
@property (weak, nonatomic) IBOutlet UITextField *ruleField;
- (IBAction)tapAddRule:(id)sender;

@end

@implementation RulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self reloadView];
    
    self.tableView.tableFooterView = [[UIView alloc]
                                      initWithFrame:CGRectZero];
}

- (void) reloadView {
    [self fetchHouse];
    [self fetchRules];
    [self.tableView reloadData];
}


- (void) fetchHouse {
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.house = [House getHouse:persona];
    }];
}


- (void) fetchRules {
    self.rules = [self.house objectForKey:@"rules"];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    RuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RuleCell"];
        
    cell.ruleLabel.text = self.rules[indexPath.row];
    cell.numberLabel.text = [NSString stringWithFormat: @"%ld", (long)(indexPath.row+1)];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rules.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.rules removeObjectAtIndex:indexPath.row];
        [self.house setObject:self.rules
                       forKey:@"rules"];
        [self.house save];
        [self reloadView];
    }
}

- (IBAction)tapAddRule:(id)sender {
    [self.house addUniqueObject:self.ruleField.text forKey:@"rules"];
    [self.house save];
    [self fetchRules];
    [self.ruleField setText:@""];
    [self.tableView reloadData];
}
@end
