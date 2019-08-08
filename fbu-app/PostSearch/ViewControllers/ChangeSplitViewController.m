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
#import "NewBillViewController.h"

@interface ChangeSplitViewController () <UITableViewDataSource, UITableViewDelegate, SplitDebtorCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ChangeSplitViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self reloadView];
}

- (void) reloadView {
    [self.tableView reloadData];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SplitDebtorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SplitDebtorCell"];
    
    NSDecimalNumber* numSplit = (NSDecimalNumber*)[NSDecimalNumber numberWithInteger:(self.debtors.count+1)];
    NSDecimalNumber *portion = [self.paid decimalNumberByDividingBy:numSplit];
    
    cell.moneyField.placeholder = [portion stringValue];
    cell.delegate = self;
    Persona *possibleDebtor = self.possibleDebtors[indexPath.row];
    [possibleDebtor fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        cell.nameLabel.text = [[possibleDebtor.firstName stringByAppendingString:@" "] stringByAppendingString:possibleDebtor.lastName];
        cell.debtor = possibleDebtor;
        if(![self.debtors containsObject:possibleDebtor]){
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            cell.moneyField.backgroundColor = [UIColor groupTableViewBackgroundColor];
            cell.moneyField.text = @"";
            cell.moneyField.placeholder = @"0.00";
            [cell.debtorSwitch setOn:NO];
        }
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
    NSUInteger index = [self.debtors indexOfObject:debtor];
    [self.debtors removeObjectAtIndex:index];
    [self.portions removeObjectAtIndex:index];
    
}

- (IBAction)tapSave:(id)sender {
    [self.delegate changeSplit:self.payer debtors:self.debtors portions:self.portions];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

