//
//  EventReminderCell.m
//  fbu-app
//
//  Created by jordan487 on 8/1/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "EventReminderCell.h"
#import "Event.h"
#import "Reminder.h"

@interface EventReminderCell()
{
    UILabel *title;
    UILabel *location;
    UILabel *startTime;
    UILabel *endTime;
}


@end

@implementation EventReminderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCellWithEvent:(Event *)event {
    title = [[UILabel alloc] initWithFrame:self.bounds];
    title.text = event.title;
    
    location = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    location.text = [NSString stringWithFormat:@"%@", event.venue];
    
    startTime = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 20, 20)];
    startTime.text = [NSString stringWithFormat:@"%@", event.eventDate];
    
    endTime = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 20, 20)];
    endTime.text = [NSString stringWithFormat:@"%@", event.eventEndDate];
    
    [self.contentView addSubview:title];
    [self.contentView addSubview:location];
    [self.contentView addSubview:startTime];
    [self.contentView addSubview:endTime];
}

- (void)initCellWithReminder:(Reminder *)reminder {
    title = [[UILabel alloc] initWithFrame:self.bounds];
    title.text = reminder.reminderText;
    
    startTime = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 20, 20)];
    startTime.text = [NSString stringWithFormat:@"%@", reminder.reminderSentDate];
    
    endTime = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 20, 20)];
    endTime.text = [NSString stringWithFormat:@"%@", reminder.reminderDueDate];
    
    [self.contentView addSubview:title];
    [self.contentView addSubview:startTime];
    [self.contentView addSubview:endTime];
}

@end
