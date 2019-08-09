//
//  HouseBalancesViewController.m
//  fbu-app
//
//  Created by sophiakaz on 8/3/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "HouseBalancesViewController.h"
#import "HousemateBalanceCell.h"
#import "House.h"
#import "Persona.h"
#import "Parse/Parse.h"
#import "Balance.h"
#import "BalanceDetailsViewController.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "CustomColor.h"

@interface HouseBalancesViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *negativeLabel;
@property (weak, nonatomic) IBOutlet UILabel *positiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (nonatomic, strong) NSMutableArray *balances;
@property (nonatomic, strong) Persona *currentPersona;
@property (nonatomic, strong) NSMutableArray *balanceTotals;
- (IBAction)tapLeftMenu:(id)sender;


@end

@implementation HouseBalancesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.currentPersona = [PFUser.currentUser objectForKey:@"persona"];
    [self.currentPersona fetchIfNeeded];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadView];
}

- (void) reloadView {
    [self fetchBalances];
    
    self.balanceTotals = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.balances.count; i++) {
        [self.balanceTotals addObject:[NSDecimalNumber zero]];
    }
    
    [self.tableView reloadData];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) fetchBalances {
    self.balances = [self.currentPersona objectForKey:@"balances"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    HousemateBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HousemateBalanceCell"];
    
    Balance *balance = self.balances[indexPath.row];
    [balance fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        NSUInteger indexOfHousemate = [self getIndex:balance];
        Persona *housemate = [self getHousemate:balance indexOfHousemate:indexOfHousemate];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        
        NSDecimalNumber* total = [NSDecimalNumber decimalNumberWithDecimal:[balance.total decimalValue]];
        [self.balanceTotals replaceObjectAtIndex:indexPath.row withObject:total];

        cell.nameLabel.text = [[housemate.firstName stringByAppendingString:@" "] stringByAppendingString:housemate.lastName];
        NSDecimalNumber *balanceTotal = [NSDecimalNumber decimalNumberWithDecimal:[balance.total decimalValue]];
        if ([balanceTotal isEqual:[NSDecimalNumber zero]]){
            cell.stateLabel.text = @"all even";
            cell.stateLabel.textColor = [UIColor darkGrayColor];
            cell.topConstraint.constant = 19;
        }
        else if([self inDebt:balance indexOfHousemate:indexOfHousemate]){
            cell.stateLabel.text = @"you owe";
            cell.stateLabel.textColor = [UIColor redColor];
            cell.balanceLabel.text = [numberFormatter stringFromNumber:[self abs:balanceTotal]];
            cell.balanceLabel.textColor = [UIColor redColor];
            [self setTotals];
            cell.topConstraint.constant = 8;
        }else if(![self inDebt:balance indexOfHousemate:indexOfHousemate]){
            cell.stateLabel.text = @"owes you";
            cell.stateLabel.textColor = [UIColor greenColor];
            cell.balanceLabel.text = [numberFormatter stringFromNumber:[self abs:balanceTotal]];
            cell.balanceLabel.textColor = [UIColor greenColor];
            [self setTotals];
            cell.topConstraint.constant = 8;
        }
        
        PFFileObject *imageFile = housemate.profileImage;
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                cell.profileView.image = [UIImage imageWithData:data];
            }
        }];
    }];
    cell.profileView.layer.cornerRadius = cell.profileView.frame.size.height /2;
    cell.profileView.layer.masksToBounds = YES;
    
    return cell;
    
}

-(void) setTotals {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    NSDecimalNumber *positive = [NSDecimalNumber zero];
    NSDecimalNumber *negative = [NSDecimalNumber zero];
    
    for(NSDecimalNumber* total in self.balanceTotals){
        if([total compare:[NSDecimalNumber zero]] == NSOrderedDescending){
            positive = [positive decimalNumberByAdding:total];
        }else if([total compare:[NSDecimalNumber zero]] == NSOrderedAscending){
            negative = [negative decimalNumberBySubtracting:total];
        }
    }
    
    self.negativeLabel.text = [numberFormatter stringFromNumber:negative];
    self.positiveLabel.text = [numberFormatter stringFromNumber:positive];
    self.totalLabel.text = [numberFormatter stringFromNumber:[positive decimalNumberBySubtracting:negative]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.balances.count;
}


- (Persona *)getHousemate:(Balance *)balance indexOfHousemate:(NSUInteger)index {
    NSArray *housemates = [balance objectForKey:@"housemates"];
    Persona *housemate = [housemates objectAtIndex:index];
    [housemate fetchIfNeeded];
    return housemate;
}

- (NSUInteger) getIndex: (Balance *)balance {
    NSArray *housemates = [balance objectForKey:@"housemates"];
    NSUInteger index = [housemates indexOfObject:self.currentPersona];
    if (index == (NSUInteger)1) return (NSUInteger)0;
    else return (NSUInteger)1;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showDetails"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Balance *balance = self.balances[indexPath.row];
        
        BalanceDetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.balance = balance;
        detailsViewController.currentPersona = self.currentPersona;
    }
}
     
        
- (IBAction)tapLeftMenu:(id)sender {
    [self showLeftViewAnimated:self];
}

@end
