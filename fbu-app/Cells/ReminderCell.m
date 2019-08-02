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
@property (weak, nonatomic) IBOutlet UILabel *sentToOrBy;
@property (strong, nonatomic) Reminder *rem;

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
    self.rem = rem;
    self.reminderTextLabel.text = rem.reminderText;
    
    NSString *dueDateString = rem.dueDateString;
    self.reminderDateLabel.text = dueDateString;
    
    if (self.received) {
        self.sentToOrBy.text = @"Sent by: ";
        NSString *firstName = rem.reminderSender[@"firstName"];
        NSString *lastName = [@" " stringByAppendingString:rem.reminderSender[@"lastName"]];
        NSString *fullName = [firstName stringByAppendingString:lastName];
        self.reminderSenderLabel.text = fullName;
    } else {
        self.sentToOrBy.text = @"Sent to: ";
        NSString *firstName = rem.reminderReceiver[@"firstName"];
        NSString *lastName = [@" " stringByAppendingString:rem.reminderReceiver[@"lastName"]];
        NSString *fullName = [firstName stringByAppendingString:lastName];
        self.reminderSenderLabel.text = fullName;
    }
    
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
