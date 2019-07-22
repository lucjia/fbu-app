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
            //add userId to array
            [requestsSent insertObject:receiver.objectId atIndex:0];
            [[PFUser currentUser] setObject:requestsSent forKey:@"requestsSent"];
            [Request createRequest:self.userInCell withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        // if the current user has already sent a request to the specific
        } else {
            [self createAlertController:@"Error sending request" message:@"You've already sent this user a request!"];
        }
    }
}

-(void)createAlertController:(NSString *)title message:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self.delegate showAlertOnTimeline:alert];
}

- (IBAction)didTapSaveRoomate:(id)sender {
    
}

@end
