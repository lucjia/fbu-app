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

static NSDateFormatter *dateFormatter;

@interface EventReminderCell()
{
    UILabel *titleLabel;
    UILabel *locationLabel;
    UILabel *eventIntervalLabel;
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
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.frame.size.width, 50)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = event.title;
    
    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, self.frame.size.width, 50)];
    locationLabel.numberOfLines = 0;
    locationLabel.text = [NSString stringWithFormat:@"%@", event.venue];
    
    // date formatter setup
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
    [dateFormatter setDateFormat:@"MMM d, h:mm a"];
    
    NSString *startTime = [dateFormatter stringFromDate:event.eventDate];
    NSString *endTime = [dateFormatter stringFromDate:event.eventEndDate];
    
    eventIntervalLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, self.frame.size.width, 50)];
    eventIntervalLabel.text = event.isAllDay ? @"All day" : [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:locationLabel];
    [self.contentView addSubview:eventIntervalLabel];
}

@end
