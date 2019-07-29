//
//  ReminderDetailViewController.h
//  fbu-app
//
//  Created by lucjia on 7/26/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReminderDetailViewController : UIViewController

@property (strong, nonatomic) Reminder *reminder;

@end

NS_ASSUME_NONNULL_END
