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
#import "Persona.h"
#import "CustomColor.h"

@interface RoommateCell()

@property (strong, nonatomic) Persona *userInCell;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendRequestButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIView *sendButtonView;

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)updateProperties:(Persona *)persona {
    self.sendButtonView.layer.cornerRadius = 5;
    
    [[persona objectForKey:@"profileImage"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        NSData *imageData = data;
        self.profileImage.image = [[UIImage alloc] initWithData:imageData];
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.layer.masksToBounds = YES;
    }];
    
    self.usernameLabel.text = [persona objectForKey:@"username"];
    self.bioLabel.text = [persona objectForKey:@"bio"];
    self.locationLabel.text = [persona objectForKey:@"city"];
    self.userInCell = persona;
}

- (IBAction)didTapSendRequest:(id)sender {
    if (PFUser.currentUser) {
        [self getReceiverPersona];
    }
}

- (void)getReceiverPersona {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // switch to a background thread and perform your expensive operation
        Persona *receiverPersona = self.userInCell;
        [receiverPersona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            Persona *senderPersona = [[PFUser currentUser] objectForKey:@"persona"];
            [senderPersona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object2, NSError * _Nullable error) {
                NSMutableArray *requestsSent = [senderPersona objectForKey:@"requestsSent"];
                NSMutableArray *acceptedRequests = [senderPersona objectForKey:@"acceptedRequests"];
                
                if (requestsSent == nil) {
                    requestsSent = [[NSMutableArray alloc] init];
                }
                if ([requestsSent containsObject:receiverPersona] == NO && [acceptedRequests containsObject:receiverPersona] == NO) {
                    [RoommateCell sendRequestToPersona:receiverPersona sender:senderPersona requestsSentToUsers:requestsSent allertReceiver:self];
                    
                    CABasicAnimation *theAnimation;
                    
                    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
                    theAnimation.duration=0.5;
                    theAnimation.repeatCount=NAN;
                    theAnimation.autoreverses = NO;
                    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
                    theAnimation.toValue=[NSNumber numberWithFloat:0.0];
                    [self.sendButtonView.layer addAnimation:theAnimation forKey:@"animateOpacity"];
                    
                } else {
                    [self createAlertController:@"Cannot Send request" message:@"You've already sent this user a request!"];
                }
            }];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            // switch back to the main thread to update your UI
            
        });
    });
}

+ (void)sendRequestToPersona:(Persona *)receiverPersona  sender:(Persona *)senderPersona requestsSentToUsers:(NSMutableArray *)requestsSent allertReceiver:(id)receiver {
    // if the user has not already sent a request to the user who they are trying to send a request to
    //add userId to array
    [requestsSent insertObject:receiverPersona atIndex:0];
    [senderPersona setObject:requestsSent forKey:@"requestsSent"];
    [Request createRequest:receiverPersona withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [senderPersona saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)createAlertController:(NSString *)title message:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    alert.view.tintColor = [CustomColor accentColor:1.0];
    
    [self.delegate showAlertOnTimeline:alert];
}

@end
