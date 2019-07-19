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

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *rules;
@property (strong, nonatomic) House *house;

@end

@implementation RulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchHouse];
    [self fetchRules];
    [self initTableView];
}


- (void) fetchHouse {
    self.house = [PFUser.currentUser objectForKey:@"house"];
}


- (void) fetchRules {
    self.rules = [self.house objectForKey:@"rules"];
    
}

- (void)initViewController {
    UIViewController * timelineViewController = [[UIViewController alloc] init];
    [self presentViewController:timelineViewController animated:YES completion:nil];
}

- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[RuleCell class] forCellReuseIdentifier:@"RuleCell"];

    [self.view addSubview:self.tableView];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"RuleCell";
    RuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RuleCell"];
    
    cell = [[RuleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    cell.ruleLabel.text = self.rules[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rules.count;
}



@end
