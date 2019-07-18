//
//  RoommateCell.m
//  fbu-app
//
//  Created by jordan487 on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "RoommateCell.h"
#import <Parse/Parse.h>

@interface RoommateCell()


@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendRequestButton;
@property (weak, nonatomic) IBOutlet UIButton *saveRoommateButton;
@property (strong, nonatomic) PFUser *userInCell;

@end

@implementation RoommateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //[self updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateProperties:(PFUser *)user {
    NSData *imageData = [[user objectForKey:@"profileImage"] getData];
    self.profileImage.image = [[UIImage alloc] initWithData:imageData];
    
    self.usernameLabel.text = [user objectForKey:@"username"];
    self.bioLabel.text = [user objectForKey:@"bio"];
    self.userInCell = user;
}

- (IBAction)didTapSendRequest:(id)sender {
    NSMutableArray *requestsSent = [PFUser.currentUser objectForKey:@"requestsSent"];
    NSMutableArray *requestsReceived = [self.userInCell objectForKey:@"requestsReceived"];
    NSString *receiver = [self.userInCell objectForKey:@"objectId"];
    
    // if the user has not already sent a request to the user who they are trying to send a request to
    if (![requestsSent containsObject:receiver]) {
        [requestsSent insertObject:self.userInCell atIndex:0];
        //[requestsReceived insertObject:PFUser.currentUser atIndex:0];
    }
    [[PFUser currentUser] saveInBackground];
    [self.userInCell saveInBackground];
}

- (IBAction)didTapSaveRoomate:(id)sender {
    
}

@end
