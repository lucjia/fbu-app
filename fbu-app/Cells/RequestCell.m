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

@property (weak, nonatomic) IBOutlet UILabel *senderOfRequestLabel;


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
    NSString *senderUsername = [[request objectForKey:@"requestSender"] objectForKey:@"username"];
    self.senderOfRequestLabel.text = [NSString stringWithFormat:@"%@ has sent you a request!", senderUsername];
}



@end
