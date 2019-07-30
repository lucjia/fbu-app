//
//  CalendarCell.h
//  fbu-app
//
//  Created by jordan487 on 7/26/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalendarCell : UICollectionViewCell

- (void)initDateLabelInCell:(NSUInteger)date;
- (void)drawCurrentDayCircle;
- (void)drawEventCircle;

@end

NS_ASSUME_NONNULL_END
