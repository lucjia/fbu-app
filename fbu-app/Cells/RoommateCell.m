//
//  RoommateCell.m
//  fbu-app
//
//  Created by jordan487 on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "RoommateCell.h"

//@interface RoommateCell()
//
//
//
//@end

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
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 30)];
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont fontWithName:@"Arial" size:12.0f];
        
        [self addSubview:self.label];
    }
    
    return self;
}

@end
