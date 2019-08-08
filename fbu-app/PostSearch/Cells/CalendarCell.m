//
//  CalendarCell.m
//  fbu-app
//
//  Created by jordan487 on 7/26/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CalendarCell.h"
#import "CustomColor.h"

@implementation CalendarCell

- (void)initDateLabelInCell:(NSUInteger)date newLabel:(BOOL)label {
    self.layer.cornerRadius = self.frame.size.width / 2;
    
    self.dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.text = [NSString stringWithFormat:@"%lu", date];
    self.dateLabel.textColor = [CustomColor midToneOne:1.0];
    
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
    self.dateLabel.textColor = [CustomColor accentColor:1.0];
}

- (void)drawEventCircle {
    [self drawCircleForCalendar:(self.frame.size.width / 2) - 2 verticalPosition:40 circleColor:[CustomColor midToneTwo:1.0]];
}

- (void)colorSelectedCell {
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [[CustomColor accentColor:1.0] CGColor];
}

- (void)decolorSelectedCell {
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [[UIColor clearColor] CGColor];
}

@end
