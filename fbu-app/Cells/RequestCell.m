//
//  RequestCell.m
//  fbu-app
//
//  Created by jordan487 on 7/19/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "RequestCell.h"
#import <Parse/Parse.h>
#import "Request.h"
#import "RequestsViewController.h"
#import "Persona.h"

@interface RequestCell ()

@property (strong, nonatomic) Request *currentRequest;
@property (weak, nonatomic) IBOutlet UIImageView *senderProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *senderOfRequestLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;

@end

@implementation RequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateProperties:(Request *)request {
    self.currentRequest = request;
    
    PFUser *user = [request objectForKey:@"requestSender"];
    NSData *imageData = [[user objectForKey:@"profileImage"] getData];
    self.senderProfileImage.image = [[UIImage alloc] initWithData:imageData];
    
    NSString *senderUsername = [user objectForKey:@"username"];
    self.senderOfRequestLabel.text = [NSString stringWithFormat:@"%@ has sent you a request!", senderUsername];
}

- (IBAction)didTapAccept:(id)sender {
    // procede to create household
    // call to delegate method in RequestsViewController
    //[self.delegate acceptRequest:self.currentRequest];
    PFGeoPoint *geo = [PFGeoPoint geoPointWithLatitude:12.0 longitude:11.0];
    NSData *data = [[PFUser currentUser][@"profileImage"] getData];
    UIImage *image = [UIImage imageWithData:data];
    [Persona createPersona:@"raa" lastName:@"raa"  bio:@"raa" profileImage:image city:@"raa"  state:@"raa"  location:geo withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapDecline:(id)sender {
    // call to delegate method in RequestsViewController
    [self.delegate declineRequest:self.currentRequest];
}

@end
