//
//  HousematesViewController.m
//  fbu-app
//
//  Created by sophiakaz on 7/22/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "HousematesViewController.h"
#import "PlainRoomateCell.h"
#import "Parse/Parse.h"
#import "House.h"
#import "Persona.h"

@interface HousematesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *housemates;

@end

@implementation HousematesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchHousemates];
    // Do any additional setup after loading the view.
}

- (void)fetchHousemates {
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeeded];
    House *house = [House getHouse:persona];
    self.housemates = [house objectForKey:@"housemates"];
    [self.tableView reloadData];
    
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

@end
