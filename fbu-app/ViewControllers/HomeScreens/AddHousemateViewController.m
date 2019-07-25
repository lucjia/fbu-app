//
//  AddHousemateViewController.m
//  fbu-app
//
//  Created by sophiakaz on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "AddHousemateViewController.h"
#import "PlainRoomateCell.h"
#import "Parse/Parse.h"
#import "House.h"
#import "Persona.h"
#import "Request.h"

@interface AddHousemateViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)tapAddHousemates:(id)sender;
@property (nonatomic, strong) NSArray *potentialHousemates;
@property (nonatomic, strong) NSMutableArray *housematesToAdd;

@end

@implementation AddHousemateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.housematesToAdd = [[NSMutableArray alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchPotentialHousemates];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc]
                                      initWithFrame:CGRectZero];
}

- (void)fetchPotentialHousemates {
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeeded];
    NSMutableArray *acceptedRequests = [persona objectForKey:@"acceptedRequests"];
    for (Persona *persona in acceptedRequests){
        [persona fetchIfNeeded];
    }
    NSArray *housemates = [self fetchHousemates];
    [acceptedRequests removeObjectsInArray:housemates];
    self.potentialHousemates = acceptedRequests;
}

- (NSArray *)fetchHousemates {
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeeded];
    House *house = [House getHouse:persona];
    return [house objectForKey:@"housemates"];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    PlainRoomateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlainRoomateCell"];
    
    Persona *persona = self.potentialHousemates[indexPath.row];
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
    return self.potentialHousemates.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Persona *persona = self.potentialHousemates[indexPath.row];
    
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.housematesToAdd removeObject:persona];
    }else{
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.housematesToAdd addObject:persona];
    }
}


- (IBAction)tapAddHousemates:(id)sender {
    if(self.housematesToAdd.count != 0){
        Persona *persona = [PFUser.currentUser objectForKey:@"persona"];
        [persona fetchIfNeeded];
        House *house = [persona objectForKey:@"house"];
        if (house == nil){
            [House createHouse:persona];
            house = [persona objectForKey:@"house"];
        }
        [house fetchIfNeeded];
        
        for(Persona *housemate in self.housematesToAdd){
            [house addToHouse:housemate];
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
