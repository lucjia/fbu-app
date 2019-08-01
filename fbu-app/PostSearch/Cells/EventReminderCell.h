//
//  EventReminderCell.h
//  fbu-app
//
//  Created by jordan487 on 8/1/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventReminderCell : UITableViewCell

- (void)initCellWithEvent:(Event *)event;

@end

NS_ASSUME_NONNULL_END
