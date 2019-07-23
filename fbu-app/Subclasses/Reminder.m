//
//  Reminder.m
//  fbu-app
//
//  Created by lucjia on 7/23/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

@dynamic reminderSender;
@dynamic reminderReceiver;
@dynamic reminderText;
@dynamic reminderSentDate;
@dynamic reminderDueDate;

+ (nonnull NSString *)parseClassName {
    return @"Reminder";
}

+ (void) createReminder:(PFUser *)receiver text:(NSString *)text dueDate:(NSDate *)dueDate withCompletion:(PFBooleanResultBlock _Nullable)completion {
    Reminder *newReminder = [Reminder new];
    newReminder.reminderSender = [PFUser currentUser];
    newReminder.reminderReceiver = receiver;
    newReminder.reminderText = text;
    newReminder.reminderSentDate = newReminder.createdAt;
    newReminder.reminderDueDate = dueDate;
    
    [newReminder saveInBackgroundWithBlock:completion];
}

@end
