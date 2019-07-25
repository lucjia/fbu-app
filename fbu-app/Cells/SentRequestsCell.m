//
//  SentRequestsCell.m
//  fbu-app
//
//  Created by jordan487 on 7/22/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "SentRequestsCell.h"
#import <Parse/Parse.h>
#import "Request.h"


@interface SentRequestsCell ()

@property (strong, nonatomic) Request *currentRequest;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *waitingLabel;

@end

@implementation SentRequestsCell

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
    
    PFUser *user = [request objectForKey:@"receiver"];
    NSData *imageData = [[user objectForKey:@"profileImage"] getData];
    self.profileImage.image = [[UIImage alloc] initWithData:imageData];
    
    self.waitingLabel.text = [NSString stringWithFormat:@"Waiting for %@ to respond", [user objectForKey:@"username"]];
}

@end
