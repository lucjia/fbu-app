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
#import "CustomColor.h"

@interface ModifyHouseViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *housemates;
@property (weak, nonatomic) IBOutlet UIButton *houseButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (strong, nonatomic) Persona *currentPersona;
@property (strong, nonatomic) House *currentHouse;
- (IBAction)tapRemove:(id)sender;

@end

@implementation ModifyHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[CustomColor darkMainColor:1.0]}];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.houseButton.layer.cornerRadius = 5;
    self.houseButton.layer.masksToBounds = YES;
    
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
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.currentPersona = (Persona*) object;
        self.currentHouse = [House getHouse:self.currentPersona];
        if(self.currentHouse != nil){
            [self.currentHouse fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                [self setButtonLabel];
                [self fetchHousemates];
                [self.tableView reloadData];
            }];
        } else {
            [self setButtonLabel];
            [self fetchHousemates];
            [self.tableView reloadData];
        }
    }];
}


- (void) setButtonLabel {
    if(self.currentHouse == nil){
            [self.houseButton setTitle:@"Create House" forState:UIControlStateNormal];
            self.removeButton.hidden = YES;
        }
        else{
            [self.houseButton setTitle:@"Add Housemates" forState:UIControlStateNormal];
            self.removeButton.hidden = NO;
        }
}

- (void)fetchHousemates {
    self.housemates = [self.currentHouse objectForKey:@"housemates"];
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
        [self.currentHouse saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [tableView reloadData];
        }];
    }
}

- (IBAction)tapRemove:(id)sender {
    [self.currentHouse removeFromHouse:self.currentPersona];
    NSArray *housemates = [self.currentHouse objectForKey:@"housemates"];
    if(housemates.count == 0){
        [self.currentHouse deleteHouse];
    }
    [self reloadView];
}
@end
