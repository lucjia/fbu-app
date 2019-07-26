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

@end

@implementation ModifyHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self setButtonLabel];
    [self fetchHousemates];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc]
                                      initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setButtonLabel];
    [self fetchHousemates];
    [self.tableView reloadData]; // to reload selected cell
}


- (void) setButtonLabel {
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeeded];
    House *house = [House getHouse:persona];
    if(house == nil){
        [self.houseButton setTitle:@"Create House" forState:UIControlStateNormal];
    }
    else{
        [self.houseButton setTitle:@"Add Housemates" forState:UIControlStateNormal];
    }
}

- (void)fetchHousemates {
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeeded];
    House *house = [House getHouse:persona];
    self.housemates = [house objectForKey:@"housemates"];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    PlainRoomateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlainRoomateCell"];
    
    Persona *persona = self.housemates[indexPath.row];
    [persona fetchIfNeeded];
    cell.nameLabel.text = [[persona.firstName stringByAppendingString:@" "] stringByAppendingString:persona.lastName];
    
    PFFileObject *imageFile = persona.profileImage;
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Image found successfully");
            cell.profileView.image = [UIImage imageWithData:data];
        }
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

@end
