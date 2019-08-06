//
//  ChangeSplitViewController.m
//  fbu-app
//
//  Created by sophiakaz on 8/5/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "ChangeSplitViewController.h"
#import "House.h"
#import "Persona.h"
#import "Parse/Parse.h"
#import "Balance.h"
#import "SplitDebtorCell.h"

@interface ChangeSplitViewController () <UITableViewDataSource, UITableViewDelegate, SplitDebtorCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray* possibleDebtors;
@property (strong,nonatomic) NSMutableArray* debtors;
@property (strong,nonatomic) Persona* payer;
@property (strong,nonatomic) NSMutableArray* portions;

@end

@implementation ChangeSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self reloadView];
}

- (void) reloadView {
    [self fetchpossibleDebtors];
    [self.tableView reloadData];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) fetchpossibleDebtors {
    Persona *persona = [PFUser.currentUser objectForKey:@"persona"];
    [persona fetchIfNeeded];
    House *house = [House getHouse:persona];
    self.possibleDebtors = [house objectForKey:@"housemates"];
    [self.possibleDebtors removeObject:self.payer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SplitDebtorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SplitDebtorCell"];
    
    Persona *debtor = self.possibleDebtors[indexPath.row];
    [debtor fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        cell.nameLabel.text = [[debtor.firstName stringByAppendingString:@" "] stringByAppendingString:debtor.lastName];
        cell.debtor = debtor;
    }];
    
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.possibleDebtors.count;
}

- (void)addDebtor:(Persona*)debtor portion:(NSDecimalNumber*)portion {
    [self.debtors addObject:debtor];
    [self.portions addObject:portion];
    
    
}
- (void)removeDebtor:(Persona*)debtor {
    NSUInteger *index = [self.debtors indexOfObject:debtor];
    [self.debtors removeObjectAtIndex:index];
    [self.portions removeObjectAtIndex:index];
}



- (IBAction)tapSave:(id)sender {
    [self.delegate changeSplit:self.payer debtors:self.debtors portions:self.portions];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)dateField:(id)sender {
}
- (IBAction)tapDateField:(id)sender {
}
@end
