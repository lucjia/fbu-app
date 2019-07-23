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

@interface HousematesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *housemates;

@end

@implementation HousematesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchHousemates];
    // Do any additional setup after loading the view.
}

- (void)fetchHousemates {
    
    self.housemates = nil; //need to fill in
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    PlainRoomateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    PFUser *user = self.housemates[indexPath.section];
    cell.nameLabel.text = nil; //[user.lastName stringByAppendingString:firstName];
    
    PFFileObject *imageFile = nil; //need to fill in
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
