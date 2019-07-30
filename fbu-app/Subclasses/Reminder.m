//
//  Reminder.m
//  fbu-app
//
//  Created by lucjia on 7/23/19.
//  Copyright © 2019 lucjia. All rights reserved.
//
//
#import "Reminder.h"
#import "Persona.h"

@implementation Reminder

@dynamic reminderSender;
@dynamic reminderReceiver;
@dynamic reminderText;
@dynamic reminderSentDate;
@dynamic reminderDueDate;
@dynamic dueDateString;

+ (nonnull NSString *)parseClassName {
    return @"Reminder";
}

+ (void) createReminder:(Persona *)receiver text:(NSString *)text dueDate:(NSDate *)dueDate dueDateString:(NSString *)dueDateString withCompletion:(PFBooleanResultBlock _Nullable)completion {
    Reminder *newReminder = [Reminder new];
    newReminder.reminderSender = [PFUser currentUser][@"persona"];
    newReminder.reminderReceiver = receiver;
    newReminder.reminderText = text;
    newReminder.reminderSentDate = newReminder.createdAt;
    newReminder.reminderDueDate = dueDate;
    newReminder.dueDateString = dueDateString;
    
    [newReminder saveInBackgroundWithBlock:completion];
}

@end
