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

@interface RequestCell ()

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
    PFUser *user = [request objectForKey:@"requestSender"];
    NSData *imageData = [[user objectForKey:@"profileImage"] getData];
    self.senderProfileImage.image = [[UIImage alloc] initWithData:imageData];
    
    NSString *senderUsername = [user objectForKey:@"username"];
    self.senderOfRequestLabel.text = [NSString stringWithFormat:@"%@ has sent you a request!", senderUsername];
}



@end
