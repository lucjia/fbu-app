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
@property (nonatomic, strong) NSMutableArray *potentialHousemates;
@property (nonatomic, strong) NSMutableArray *housematesToAdd;
@property (weak, nonatomic) IBOutlet UIButton *houseButton;
@property (strong, nonatomic) Persona *currentPersona;
@property (strong, nonatomic) House *currentHouse;

@end

@implementation AddHousemateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.housematesToAdd = [[NSMutableArray alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.currentPersona = (Persona*) object;
        self.currentHouse = [House getHouse:self.currentPersona];
        if(self.currentHouse != nil){
            [self.currentHouse fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                [self setButtonLabel];
                [self fetchPotentialHousemates];
                [self.tableView reloadData];
            }];
        } else {
            [self setButtonLabel];
            [self fetchPotentialHousemates];
            [self.tableView reloadData];
        }
    }];
    
    self.tableView.tableFooterView = [[UIView alloc]
                                      initWithFrame:CGRectZero];
}

- (void) setButtonLabel {
    if(self.currentHouse == nil){
        [self.houseButton setTitle:@"Create House" forState:UIControlStateNormal];
    }
    else{
        [self.houseButton setTitle:@"Add Housemates" forState:UIControlStateNormal];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)fetchPotentialHousemates {
    NSMutableArray *acceptedRequests = [self.currentPersona objectForKey:@"acceptedRequests"];
    NSMutableArray *potentials = [[NSMutableArray alloc] init];
    [potentials addObjectsFromArray:acceptedRequests];
    for (Persona *housemate in acceptedRequests){
        [housemate fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if([housemate objectForKey:@"house"] != nil){
                [potentials removeObject:housemate];
                self.potentialHousemates = potentials;
            }
            [self.tableView reloadData];
        }];
    }
    self.potentialHousemates = potentials;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    PlainRoomateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlainRoomateCell"];
    
    Persona *persona = self.potentialHousemates[indexPath.row];
    [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        cell.nameLabel.text = [[persona.firstName stringByAppendingString:@" "] stringByAppendingString:persona.lastName];
        
        PFFileObject *imageFile = persona.profileImage;
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                cell.profileView.image = [UIImage imageWithData:data];
            }
        }];
        cell.profileView.layer.cornerRadius = cell.profileView.frame.size.height /2;
        cell.profileView.layer.masksToBounds = YES;
    }];
    
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
    
    if(self.currentHouse == nil){
        [House createHouse:self.currentPersona];
        self.currentHouse = [self.currentPersona objectForKey:@"house"];
        if(self.housematesToAdd.count == 0){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if(self.housematesToAdd.count != 0){
        for(Persona *housemate in self.housematesToAdd){
            [self.currentHouse addToHouse:housemate];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
