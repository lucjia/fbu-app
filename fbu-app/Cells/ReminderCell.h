//
//  ReminderCell.h
//  fbu-app
//
//  Created by lucjia on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReminderCell : UITableViewCell

- (void) updateReminderCellWithReminder:(Reminder *)rem;

@end

NS_ASSUME_NONNULL_END
