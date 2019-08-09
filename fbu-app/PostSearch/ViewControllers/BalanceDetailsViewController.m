//  BalanceDetailsViewController.m
//  fbu-app
//
//  Created by sophiakaz on 8/7/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "BalanceDetailsViewController.h"

@interface BalanceDetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalBalanceLabel;
@property (assign, nonatomic) NSUInteger indexOfHousemate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalTopConstraint;

@end

@implementation BalanceDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSUInteger index = [self.balance.housemates indexOfObject:self.currentPersona];
    if(index == 0){
        self.indexOfHousemate = (NSUInteger)1;
        self.housemate = self.balance.housemates[1];
    }else{
        self.indexOfHousemate = (NSUInteger)2;
        self.housemate = self.balance.housemates[0];
    }
    [self.housemate fetchIfNeeded];
    
    self.navigationItem.title = [[self.housemate.firstName stringByAppendingString:@" "] stringByAppendingString:self.housemate.lastName];
    
    [self reloadView];
}

- (void) reloadView {
    [self fetchBills];
    [self setTotals];
    [self.tableView reloadData];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) fetchBills {
    self.bills = self.balance.bills;
    self.bills = [[self.bills reverseObjectEnumerator] allObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillCell"];
    
    Bill *bill = self.bills[indexPath.row];
    [bill fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        
        [bill.payer fetchIfNeeded];
        cell.payerLabel.text = [[bill.payer.firstName stringByAppendingString:@" "] stringByAppendingString:bill.payer.lastName];
        cell.payerLabel.text = [cell.payerLabel.text stringByAppendingString:@" paid "];
        cell.payerLabel.text = [cell.payerLabel.text stringByAppendingString:[numberFormatter stringFromNumber:bill.paid]];
        
        NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
        monthFormatter.dateFormat = @"MMM";
        cell.monthLabel.text = [[monthFormatter stringFromDate:bill.date] uppercaseString];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"d";
        cell.dateLabel.text = [dateFormatter stringFromDate:bill.date];
        
        cell.moneyLabel.text = [numberFormatter stringFromNumber:bill.paid];
        cell.memoLabel.text = bill.memo;
        
        [bill.payer fetchIfNeeded];
        if (![self.currentPersona isEqual:bill.payer]){
            cell.stateLabel.text = @"you borrowed";
            cell.stateLabel.textColor = [UIColor redColor];
            cell.moneyLabel.text = [numberFormatter stringFromNumber:[self getBorrowed:bill]];
            cell.moneyLabel.textColor = [UIColor redColor];
        }else if([self.currentPersona isEqual:bill.payer]){
            cell.stateLabel.text = @"you lent";
            cell.stateLabel.textColor = [UIColor greenColor];
            cell.moneyLabel.text = [numberFormatter stringFromNumber:[self getLent:bill]];
            cell.moneyLabel.textColor = [UIColor greenColor];
        }
        
    }];
    
    return cell;
    
}

- (void) setTotals{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    NSDecimalNumber* total = [NSDecimalNumber decimalNumberWithDecimal:[self.balance.total decimalValue]];
    
    if ([self.balance.total isEqual:[NSDecimalNumber zero]]){
        self.totalStateLabel.text = @"all even";
        self.totalStateLabel.textColor = [UIColor darkGrayColor];
        self.totalTopConstraint.constant = 41;
    }
    else if([self inDebt:self.balance indexOfHousemate:self.indexOfHousemate]){
        self.totalStateLabel.text = @"you owe";
        self.totalStateLabel.textColor = [UIColor redColor];
        self.totalBalanceLabel.text = [numberFormatter stringFromNumber:[self abs:total]];
        self.totalBalanceLabel.textColor = [UIColor redColor];
        self.totalTopConstraint.constant = 30;
    }else{
        self.totalStateLabel.text = @"owes you";
        self.totalStateLabel.textColor = [UIColor greenColor];
        self.totalBalanceLabel.text = [numberFormatter stringFromNumber:[self abs:total]];
        self.totalBalanceLabel.textColor = [UIColor greenColor];
        self.totalTopConstraint.constant = 30;
    }
}

- (BOOL) inDebt:(Balance *)balance indexOfHousemate:(NSUInteger)index {
    NSDecimalNumber *balanceTotal = [NSDecimalNumber decimalNumberWithDecimal:[balance.total decimalValue]];
    if (index == (NSUInteger)0) {
        if (balanceTotal > 0) return NO;
        else return YES;
    }else{
        if (balanceTotal > 0) return YES;
        else return NO;
    }
    return nil;
}

- (NSDecimalNumber *)abs:(NSDecimalNumber *)num {
    if ([num compare:[NSDecimalNumber zero]] == NSOrderedAscending ) {
        NSDecimalNumber *negativeOne = [NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:YES];
        return [num decimalNumberByMultiplyingBy:negativeOne];
    } else {
        return num;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bills.count;
}

- (NSDecimalNumber*) getBorrowed:(Bill*)bill {
    NSUInteger index = [bill.debtors indexOfObject:self.currentPersona];
    return bill.portions[index];
}

- (NSDecimalNumber*) getLent:(Bill*)bill {
    NSUInteger index = [bill.debtors indexOfObject:self.housemate];
    return bill.portions[index];
}

@end
