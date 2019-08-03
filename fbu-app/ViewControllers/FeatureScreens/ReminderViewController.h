//
//  ReminderViewController.h
//  fbu-app
//
//  Created by lucjia on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReminderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *receivedReminderArrayDates;
@property (strong, nonatomic) NSMutableArray *receivedReminderArrayNoDates;
@property (strong, nonatomic) NSMutableArray *receivedReminderArrayTotal;
@property (assign, nonatomic) NSInteger segmentIndex;

- (void) queryForReminders;

@end

NS_ASSUME_NONNULL_END
