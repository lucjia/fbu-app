//
//  PreferenceCell.m
//  fbu-app
//
//  Created by lucjia on 7/17/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "PreferenceCell.h"
#import "Parse/Parse.h"
#import "DownPicker.h"

@interface PreferenceCell ()

@property (strong, nonatomic) UILabel *ruleLabel;
@property (strong, nonatomic) UITextField *answerField;
@property (strong, nonatomic) DownPicker *downPicker;

@end

@implementation PreferenceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
} 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:@"PreferenceCell"];
    
    [self setRuleLabel];
    
    return self;
}

- (void)setRuleLabel {
    if (self) {
        self.ruleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 30)];
        self.ruleLabel.textColor = [UIColor blackColor];
        self.ruleLabel.font = [UIFont fontWithName:@"Arial" size:16.0f];
        [self addSubview:self.ruleLabel];
        
        self.answerField = [[UITextField alloc] initWithFrame:CGRectMake(300, 10, 200, 30)];
        self.answerField.textColor = [UIColor blackColor];
        self.answerField.font = [UIFont fontWithName:@"Arial" size:16.0f];
        [self addSubview:self.downPicker];
        [self addSubview:self.answerField];
    }
}

- (void)updateProperties {
    self.ruleLabel.text = self.preferenceQ;
    self.downPicker = [[DownPicker alloc] initWithTextField:self.answerField withData:self.answerArray];
}

@end
