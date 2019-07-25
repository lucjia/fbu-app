//
//  ReminderCell.m
//  fbu-app
//
//  Created by lucjia on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "ReminderCell.h"

@interface ReminderCell()

@property (weak, nonatomic) IBOutlet UILabel *reminderTextLabel;

@end

@implementation ReminderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateReminderCell {
    self.reminderTextLabel.text = @"hi";
}

@end
