//
//  CalendarCell.m
//  fbu-app
//
//  Created by jordan487 on 7/26/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CalendarCell.h"

@interface CalendarCell()

@property (strong, nonatomic) UILabel *dateLabel;

@end

@implementation CalendarCell

- (void)initDateLabelInCell:(NSUInteger)date {
    self.dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.text = [NSString stringWithFormat:@"%lu", date];
    
    [self.contentView addSubview:self.dateLabel];
}

- (void)modifyDateLabelInCell:(NSUInteger)date {
    self.dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.text = [NSString stringWithFormat:@"%lu", date];
}

- (void)drawCircleForCalendar:(NSInteger)x verticalPosition:(NSInteger)y circleColor:(UIColor *)color {
    CAShapeLayer *circle = [CAShapeLayer layer];
    [circle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y, 5, 5)] CGPath]];
    [circle setStrokeColor:[color CGColor]];
    [circle setFillColor:[color CGColor]];
    
    [[self.contentView layer] addSublayer:circle];
}

- (void)setCurrentDayTextColor {
    self.dateLabel.textColor = [UIColor redColor];
}

- (void)drawCurrentDayCircle {
    [self drawCircleForCalendar:10 verticalPosition:10 circleColor:[UIColor redColor]];
}

- (void)drawEventCircle {
    [self drawCircleForCalendar:20 verticalPosition:10 circleColor:[UIColor blueColor]];
}

@end
