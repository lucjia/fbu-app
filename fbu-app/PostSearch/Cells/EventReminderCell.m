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
#import "CustomColor.h"

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)createView {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screen.size.width;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, self.contentView.frame.size.height * 2)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    view.layer.cornerRadius = 15;
    
    [self.contentView addSubview:view];
}

- (void)createSideView {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screen.size.width;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth / 30, self.contentView.frame.size.height * 2)];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: view.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: (CGSize){15.0, 10.}].CGPath;
    
    view.layer.mask = maskLayer;
    
    [view setBackgroundColor:[CustomColor accentColor:1.0]];
    
    [self.contentView addSubview:view];
}

- (void)initCellWithEvent:(Event *)event {
    [self createView];
    [self createSideView];
    
    self.layer.cornerRadius = 15;
    self.contentView.layer.masksToBounds = YES;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width, 50)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = event.title;
    titleLabel.textColor = [CustomColor darkMainColor:1.0];
    
    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width, 50)];
    locationLabel.numberOfLines = 0;
    locationLabel.text = [NSString stringWithFormat:@"%@", event.venue];
    locationLabel.textColor = [CustomColor darkMainColor:1.0];
    
    // date formatter setup
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
    [dateFormatter setDateFormat:@"MMM d, h:mm a"];
    
    NSString *startTime = [dateFormatter stringFromDate:event.eventDate];
    NSString *endTime = [dateFormatter stringFromDate:event.eventEndDate];
    
    eventIntervalLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, self.frame.size.width, 50)];
    eventIntervalLabel.text = event.isAllDay ? @"All day" : [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    eventIntervalLabel.textColor = [CustomColor darkMainColor:1.0];
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:locationLabel];
    [self.contentView addSubview:eventIntervalLabel];
}

@end
