//
//  CalendarCell.m
//  fbu-app
//
//  Created by jordan487 on 7/26/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CalendarCell.h"

@interface CalendarCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation CalendarCell

- (void)updateProperties:(NSInteger)date {
    self.dateLabel.text = [NSString stringWithFormat:@"%lu", date];
}

@end
