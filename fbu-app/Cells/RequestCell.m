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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)updateProperties:(Request *)request {
    self.currentRequest = request;
    
    PFUser *user = [request objectForKey:@"sender"];
    [[user objectForKey:@"profileImage"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        NSData *imageData = data;
        self.senderProfileImage.image = [[UIImage alloc] initWithData:imageData];
        self.senderProfileImage.layer.cornerRadius = self.senderProfileImage.layer.frame.size.height / 2;
        self.senderProfileImage.layer.masksToBounds = YES;
    }];
    
    NSString *senderUsername = [user objectForKey:@"username"];
    self.senderOfRequestLabel.text = [NSString stringWithFormat:@"%@ has sent you a request!", senderUsername];
    
    self.acceptButton.layer.cornerRadius = 5;
    self.acceptButton.layer.masksToBounds = YES;
    self.rejectButton.layer.cornerRadius = 5;
    self.rejectButton.layer.masksToBounds = YES;
}

- (IBAction)didTapAccept:(id)sender {
    // proceed to create household
    // call to delegate method in RequestsViewController
    [self.delegate acceptRequest:self.currentRequest];
}

- (IBAction)didTapDecline:(id)sender {
    // call to delegate method in RequestsViewController
    [self.delegate declineRequest:self.currentRequest];
}

@end
