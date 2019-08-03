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

@interface HouseBalancesViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *negativeLabel;
@property (weak, nonatomic) IBOutlet UILabel *positiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (nonatomic, strong) NSMutableArray *balances;
@property (nonatomic, strong) Persona *currentPersona;

@end

@implementation HouseBalancesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.currentPersona = [PFUser.currentUser objectForKey:@"persona"];
    [self.currentPersona fetchIfNeededInBackground];
    
    [self fetchBalances];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) fetchBalances {
    self.balances = [PFUser.currentUser objectForKey:@"balances"];
    /*
     if(self.balances.count == 0 && self.currentPersona.house != nil){
        House *house = [House getHouse:self.currentPersona];
        for(Persona* housemate )
        Balance *balance = [Balance createBalance:self.currentPersona housemateTwo:housemate totalBalance:(NSNumber)0 withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            housemate
        }]
    }
     */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    HousemateBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HousemateBalanceCell"];
    
    Balance *balance = self.balances[indexPath.row];
    [balance fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        NSUInteger indexOfHousemate = [self getIndex:balance];
        Persona *housemate = [self getHousemate:balance indexOfHousemate:indexOfHousemate];
        
        cell.nameLabel.text = [[housemate.firstName stringByAppendingString:@" "] stringByAppendingString:housemate.lastName];
        cell.balanceLabel.text = [[NSNumber numberWithDouble:fabs([balance.total doubleValue])] stringValue];
        if([self inDebt:balance indexOfHousemate:indexOfHousemate]){
            cell.stateLabel.text = @"you owe";
            
        }else{
            cell.stateLabel.text = @"owes you";
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.balances.count;
}

- (Persona *)getHousemate:(Balance *)balance indexOfHousemate:(NSUInteger)index {
    NSArray *housemates = [balance objectForKey:@"housemates"];
    Persona *housemate = [housemates objectAtIndex:index];
    [housemate fetchInBackground];
    return housemate;
}

- (NSUInteger) getIndex: (Balance *)balance {
    NSArray *housemates = [balance objectForKey:@"housemates"];
    NSUInteger index = [housemates indexOfObject:self.currentPersona];
    if (index == (NSUInteger)1) return (NSUInteger)0;
    else return (NSUInteger)1;
}

- (BOOL) inDebt:(Balance *)balance indexOfHousemate:(NSUInteger)index {
    if (index == (NSUInteger)0) {
        if (balance.total >= 0) return NO;
        else return YES;
    }else{
        if (balance.total >= 0) return YES;
        else return NO;
    }
}


@end
