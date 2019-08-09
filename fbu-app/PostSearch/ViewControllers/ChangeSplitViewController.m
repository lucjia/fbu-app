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
#import "CustomColor.h"

@interface ChangeSplitViewController () <UITableViewDataSource, UITableViewDelegate, SplitDebtorCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayCells;
- (IBAction)tapSplitEqually:(id)sender;


@end

@implementation ChangeSplitViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[CustomColor darkMainColor:1.0]}];
    
    self.arrayCells = [[NSMutableArray alloc] init];
    
    [self reloadView];
}

- (void) reloadView {
    [self.tableView reloadData];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SplitDebtorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SplitDebtorCell"];
    
    cell.delegate = self;
    Persona *possibleDebtor = self.possibleDebtors[indexPath.row];
    [possibleDebtor fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        cell.paid = self.paid;
        cell.nameLabel.text = [self getName:possibleDebtor];
        cell.debtor = possibleDebtor;
        cell.indexPath = indexPath;
        if(![self.debtors containsObject:possibleDebtor]){
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            cell.moneyField.backgroundColor = [UIColor groupTableViewBackgroundColor];
            cell.moneyField.text = @"";
            cell.moneyField.placeholder = [self formatCurrency:[NSDecimalNumber zero]];
            [cell.debtorSwitch setOn:NO];
        }
        else{
            NSUInteger index = [self.debtors indexOfObject:possibleDebtor];
            cell.backgroundColor = [UIColor clearColor];
            cell.moneyField.backgroundColor = [UIColor clearColor];
            [cell.debtorSwitch setOn:YES];
            cell.moneyField.text = [self formatCurrency:self.portions[index]];
        }
    }];
    [self.arrayCells addObject:cell];
    
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.possibleDebtors.count;
}

- (void)addDebtor:(Persona*)debtor portion:(NSDecimalNumber*)portion indexPath:(NSIndexPath*)indexPath {
    [self.debtors addObject:debtor];
    [self.portions addObject:portion];
    NSArray* indexArray = [NSArray arrayWithObjects:indexPath, nil];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
    
}
- (void)removeDebtor:(Persona*)debtor indexPath:(NSIndexPath*)indexPath {
    NSUInteger index = [self.debtors indexOfObject:debtor];
    [self.debtors removeObjectAtIndex:index];
    [self.portions removeObjectAtIndex:index];
    NSArray* indexArray = [NSArray arrayWithObjects:indexPath, nil];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
}

- (void) updatePortions {
    for(int i = 0; i < self.possibleDebtors.count; i++){
        SplitDebtorCell *cell = self.arrayCells[i];
        if([self.debtors containsObject:cell.debtor]){
            NSUInteger index = [self.debtors indexOfObject:cell.debtor];
            if ([cell.moneyField.text length] > 1){
                self.portions[index] = [NSDecimalNumber decimalNumberWithString:[cell.moneyField.text substringFromIndex:1]];
            }else{
                self.portions[index] = [NSDecimalNumber zero];
            }
        }
    }
}

- (IBAction)tapSave:(id)sender {
    [self updatePortions];
    [self.delegate changeSplit:self.payer debtors:self.debtors portions:self.portions];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *) formatCurrency:(NSDecimalNumber*)money {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    return [numberFormatter stringFromNumber:money];
}


- (IBAction)tapSplitEqually:(id)sender {
    NSDecimalNumber* numSplit = (NSDecimalNumber*)[NSDecimalNumber numberWithInteger:(self.debtors.count+1)];
    NSDecimalNumber *portion = [self.paid decimalNumberByDividingBy:numSplit];
    self.portions = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.debtors.count; i++) {
        [self.portions addObject:portion];
    }
    [self reloadView];
}

- (NSString *) getName:(Persona*)persona {
    if([persona isEqual:[PFUser.currentUser objectForKey:@"persona"]]){
        return @"You";
    }else{
        return [[persona.firstName stringByAppendingString:@" "] stringByAppendingString:persona.lastName];
    }
}

@end

