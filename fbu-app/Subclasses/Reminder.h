//
//  Reminder.h
//  fbu-app
//
//  Created by lucjia on 7/23/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Reminder : PFObject<PFSubclassing>

@property (strong, nonatomic) PFUser *reminderSender;
@property (strong, nonatomic) PFUser *reminderReceiver;
@property (strong, nonatomic) NSString *reminderText;
@property (strong, nonatomic) NSDate *reminderSentDate;
@property (strong, nonatomic) NSDate *reminderDueDate;

// Make sure this is for the Persona
+ (void) createReminder:(PFUser *)receiver text:(NSString *)text dueDate:(NSDate *)dueDate withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
