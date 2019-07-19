//
//  RuleCell.m
//  fbu-app
//
//  Created by sophiakaz on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "RuleCell.h"

@implementation RuleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@synthesize ruleLabel = _ruleLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self setRuleLabel];
    
    return self;
}

- (void)setRuleLabel {
    if (self) {
        self.ruleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 30)];
        self.ruleLabel.textColor = [UIColor blackColor];
        self.ruleLabel.font = [UIFont fontWithName:@"Arial" size:24.0f];
        
        [self addSubview:self.ruleLabel];
    }
}


@end
