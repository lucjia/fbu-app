//
//  ReminderCell.m
//  fbu-app
//
//  Created by lucjia on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "ReminderCell.h"
#import "Reminder.h"

@interface ReminderCell()

@property (weak, nonatomic) IBOutlet UILabel *reminderTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderDateLabel;

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

- (void) updateReminderCellWithReminder:(Reminder *)rem {
    self.reminderTextLabel.text = rem.reminderText;
    
    NSString *dueDateString = rem.dueDateString;
    self.reminderDateLabel.text = dueDateString;
}

@end
