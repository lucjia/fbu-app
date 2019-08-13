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
@property (weak, nonatomic) IBOutlet UIView *cellView;

@end

@implementation SentRequestsCell

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
    
    self.cellView.layer.cornerRadius = 15;
    [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    PFUser *user = [request objectForKey:@"receiver"];
    [[user objectForKey:@"profileImage"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        NSData *imageData = data;
        self.profileImage.image = [[UIImage alloc] initWithData:imageData];
        self.profileImage.layer.cornerRadius = self.profileImage.layer.frame.size.height / 2;
        self.profileImage.layer.masksToBounds = YES;
    }];
    
    self.waitingLabel.text = [NSString stringWithFormat:@"Waiting for %@ to respond", [user objectForKey:@"username"]];
}

@end
