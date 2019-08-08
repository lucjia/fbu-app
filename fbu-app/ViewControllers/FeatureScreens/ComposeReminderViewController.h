//
//  ComposeReminderViewController.h
//  fbu-app
//
//  Created by lucjia on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeReminderViewControllerDelegate

- (void) refreshWithNewReminder:(Reminder *)rem;

@end

@interface ComposeReminderViewController : UIViewController

@property (nonatomic, weak) id<ComposeReminderViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
