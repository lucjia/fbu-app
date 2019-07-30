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
@property (weak, nonatomic) IBOutlet UILabel *reminderSenderLabel;

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
    
    NSString *firstName = rem.reminderSender[@"firstName"];
    NSString *lastName = [@" " stringByAppendingString:rem.reminderSender[@"lastName"]];
    NSString *fullName = [firstName stringByAppendingString:lastName];
    self.reminderSenderLabel.text = fullName;

    if(rem.completed) {
        self.checkmarkButton.selected = YES;
        [self.checkmarkButton setImage:[UIImage imageNamed:@"Checkmark"] forState:UIControlStateSelected];
    } else {
        self.checkmarkButton.selected = NO;
    }
}

- (IBAction)didPressCheck:(id)sender {
    // toggle selected
    NSNumber *selected;
    if (self.checkmarkButton.selected == YES) {
        self.checkmarkButton.selected = NO;
        selected = @NO;
    } else {
        self.checkmarkButton.selected = YES;
        selected = @YES;
    }
    
    // save state of completion into parse
    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.rem[@"objectId"]
                                 block:^(PFObject *reminder, NSError *error) {
                                     reminder = self.rem;
                                     reminder[@"completed"] = selected;
                                     [reminder saveInBackground];
                                     [self refreshCheckState];
                                 }];
}

- (void) refreshCheckState {
    [self.checkmarkButton setImage:[UIImage imageNamed:@"Checkmark"] forState:UIControlStateSelected];
}

@end
