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

@property (strong, nonatomic) UILabel *label;

@end

@implementation RoommateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@synthesize label = _label;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    [self setUsernameLabel];
    
    return self;
}

- (void)setUsernameLabel {
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 30)];
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont fontWithName:@"Arial" size:24.0f];
        
        [self addSubview:self.label];
    }
}

- (void)updateProperties:(PFUser *)user {
    //username label
    self.label.text = [user objectForKey:@"username"];
}

@end
