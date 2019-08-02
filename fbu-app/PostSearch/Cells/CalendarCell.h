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

@property (strong, nonatomic) UILabel *dateLabel;

- (void)initDateLabelInCell:(NSUInteger)date newLabel:(BOOL)label;
- (void)setCurrentDayTextColor;
- (void)drawCurrentDayCircle;
- (void)drawEventCircle;
- (void)colorSelectedCell;
- (void)decolorSelectedCell;

@end

NS_ASSUME_NONNULL_END
