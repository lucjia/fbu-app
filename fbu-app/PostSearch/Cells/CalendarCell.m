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

@end
