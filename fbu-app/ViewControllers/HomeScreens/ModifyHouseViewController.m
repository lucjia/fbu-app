//
//  ModifyHouseViewController.m
//  fbu-app
//
//  Created by sophiakaz on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "ModifyHouseViewController.h"
#import "PlainRoomateCell.h"
#import "Parse/Parse.h"
#import "House.h"
#import "Persona.h"

@interface ModifyHouseViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *housemates;
@property (weak, nonatomic) IBOutlet UIButton *houseButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
- (IBAction)tapRemove:(id)sender;

@end

@implementation ModifyHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self reloadView];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc]
                                      initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadView];
}

- (void) reloadView {
    [self setButtonLabel];
    [self fetchHousemates];
}


- (void) setButtonLabel {
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        House *house = [object objectForKey:@"house"];
        [house fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if(house == nil){
                [self.houseButton setTitle:@"Create House" forState:UIControlStateNormal];
                self.removeButton.hidden = YES;
            }
            else{
                [self.houseButton setTitle:@"Add Housemates" forState:UIControlStateNormal];
                self.removeButton.hidden = NO;
            }
        }];
    }];
}

- (void)fetchHousemates {
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        House *house = [persona objectForKey:@"house"];
        [house fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            self.housemates = [house objectForKey:@"housemates"];
            [self.tableView reloadData];
        }];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    PlainRoomateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlainRoomateCell"];
    
    Persona *persona = self.housemates[indexPath.row];
    [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        cell.nameLabel.text = [[persona.firstName stringByAppendingString:@" "] stringByAppendingString:persona.lastName];
        
        PFFileObject *imageFile = persona.profileImage;
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
    return self.housemates.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Persona *persona = self.housemates[indexPath.row];
        [[House getHouse:persona] removeFromHouse:persona];
        [self.housemates removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
    }
}

- (IBAction)tapRemove:(id)sender {
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        House *house = [House getHouse:persona];
        [house removeFromHouse:persona];
        NSArray *housemates = [house objectForKey:@"housemates"];
        if(housemates.count == 0){
            [house deleteHouse];
        }
        [self reloadView];
    }];
}
@end
