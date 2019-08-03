//
//  CalendarCell.m
//  fbu-app
//
//  Created by jordan487 on 7/26/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CalendarCell.h"

@implementation CalendarCell

- (void)initDateLabelInCell:(NSUInteger)date newLabel:(BOOL)label {
    self.dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.text = [NSString stringWithFormat:@"%lu", date];
    
    if (label) {
        [self.contentView addSubview:self.dateLabel];
    }
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

- (void)colorSelectedCell {
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [[UIColor colorWithRed:66/255.0 green:245/255.0 blue:152/255.0 alpha:1] CGColor];
}

- (void)decolorSelectedCell {
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [[UIColor clearColor] CGColor];
}

@end
