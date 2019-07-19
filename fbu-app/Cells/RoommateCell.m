//
//  RoommateCell.m
//  fbu-app
//
//  Created by jordan487 on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "RoommateCell.h"
#import <Parse/Parse.h>
#import "Request.h"

@interface RoommateCell()

@property (strong, nonatomic) PFUser *userInCell;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendRequestButton;
@property (weak, nonatomic) IBOutlet UIButton *saveRoommateButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

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
    if (PFUser.currentUser) {
        NSMutableArray *requestsSent = [PFUser.currentUser objectForKey:@"requestsSent"];
        PFUser *receiver = self.userInCell;
        
         //BOOL b = [[PFUser currentUser] isAuthenticated];
        if (requestsSent == nil) {
            requestsSent = [[NSMutableArray alloc] init];
        }
        
        // if the user has not already sent a request to the user who they are trying to send a request to
        if (![requestsSent containsObject:receiver.objectId]) {
            
//            [requestsSent insertObject:self.userInCell.objectId atIndex:0];
//            [requestsReceived insertObject:PFUser.currentUser.objectId atIndex:0];
//        }
//        [[PFUser currentUser] setObject:requestsSent forKey:@"sentRequests"];
//        [self.userInCell setObject:requestsReceived forKey:@"receivedRequests"];
//        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//            if (error) {
//                NSLog(@"CURR: %@", error.localizedDescription);
//            } else {
//                NSLog(@"CURR: YAAYYYY");
//            }
//        }];
//        [self.userInCell saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//            if (error) {
//                NSLog(@"SELF: %@", error.localizedDescription);
//            } else {
//                NSLog(@"SELF: YAAYYYY");
//            }
//        }];
            
            [requestsSent insertObject:receiver.objectId atIndex:0];
            [[PFUser currentUser] setObject:requestsSent forKey:@"requestsSent"];
            [Request createRequest:self.userInCell withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"CURR: %@", error.localizedDescription);
                } else {
                    NSLog(@"CURR: YAAYYYY");
                }

            }];
        }
    }
}



- (IBAction)didTapSaveRoomate:(id)sender {
    
}

@end
