//
//  BillDetailsViewController.m
//  fbu-app
//
//  Created by sophiakaz on 8/9/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "BillDetailsViewController.h"
#import "DebtorCell.h"
#import "CustomColor.h"

@interface BillDetailsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
@property (weak, nonatomic) IBOutlet UILabel *datelabel;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NSMutableArray *people;
NSDecimalNumber *sumDebt;

@implementation BillDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.memoLabel.text = self.bill.memo;
    self.datelabel.text = [@"Paid on " stringByAppendingString:[self formatDate:self.bill.date]];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    self.paidLabel.text = [numberFormatter stringFromNumber:self.bill.paid];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[CustomColor darkMainColor:1.0]}];

    
    PFFileObject *imageFile = self.bill.image;
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.pictureView.image = [UIImage imageWithData:data];
        }
    }];
    
    //self.navigationItem.title = self.bill.memo;
    
    [self reloadView];
}

- (void) reloadView {
    [self fetchPeople];
    
    sumDebt = [NSDecimalNumber zero];
    for(int i = 0; i < people.count - 1; i ++){
        NSDecimalNumber *portion = [NSDecimalNumber decimalNumberWithDecimal:[self.bill.portions[i] decimalValue]];
        sumDebt = [sumDebt decimalNumberByAdding:portion];
    }
    
    [self.tableView reloadData];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) fetchPeople {
    people = [self.bill.debtors mutableCopy];
    [people insertObject:self.bill.payer atIndex:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    DebtorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DebtorCell"];
    
    Persona *housemate = people[indexPath.row];
    [housemate fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        
        cell.nameLabel.text = [self getName:housemate];
        
        PFFileObject *imageFile = housemate.profileImage;
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                cell.pictureView.image = [UIImage imageWithData:data];
            }
        }];
        cell.pictureView.layer.cornerRadius = cell.pictureView.frame.size.height /2;
        cell.pictureView.layer.masksToBounds = YES;
        
        if(indexPath.row == 0){
            
            [cell.extraTextLabel setHidden:NO];
            [cell.extraMoneyLabel setHidden:NO];
            
            cell.owesLabel.text = @" paid ";
            cell.portionLabel.text = [numberFormatter stringFromNumber:self.bill.paid];
            
            PFFileObject *imageFile = housemate.profileImage;
            [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (!error) {
                    cell.pictureView.image = [UIImage imageWithData:data];
                }
            }];
            cell.pictureView.layer.cornerRadius = cell.pictureView.frame.size.height /2;
            cell.pictureView.layer.masksToBounds = YES;
            
            NSDecimalNumber *paid = [NSDecimalNumber decimalNumberWithDecimal:[self.bill.paid decimalValue]];
            cell.extraMoneyLabel.text = [numberFormatter stringFromNumber:[paid decimalNumberBySubtracting:sumDebt]];
            
        }else{
        
            cell.portionLabel.text = [numberFormatter stringFromNumber:self.bill.portions[indexPath.row - 1]];
            cell.owesLabel.text = @" owed ";
            
            [cell.extraTextLabel setHidden:YES];
            [cell.extraMoneyLabel setHidden:YES];
        }
        
        
        
    }];
    
    return cell;
    
}
                      
- (NSString *)formatDate:(NSDate *)date
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
        NSString *formattedDate = [dateFormatter stringFromDate:date];
        return formattedDate;
    }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return people.count;
}

- (NSString *) getName:(Persona*)persona {
    if([persona isEqual:self.currentPersona]){
        return @"You";
    }else{
        return [[persona.firstName stringByAppendingString:@" "] stringByAppendingString:persona.lastName];
    }
}

@end
