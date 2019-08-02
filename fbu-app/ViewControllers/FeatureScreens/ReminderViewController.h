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

@property (strong, nonatomic) NSArray *receivedReminderArrayDates;
@property (strong, nonatomic) NSArray *receivedReminderArrayNoDates;
@property (strong, nonatomic) NSArray *receivedReminderArrayTotal;
@property (assign, nonatomic) NSInteger segmentIndex;

@end

NS_ASSUME_NONNULL_END
