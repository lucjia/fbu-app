//
//  Reminder.h
//  fbu-app
//
//  Created by lucjia on 7/23/19.
//  Copyright © 2019 lucjia. All rights reserved.
//
//

#import <Parse/Parse.h>
#import "Persona.h"

NS_ASSUME_NONNULL_BEGIN

@interface Reminder : PFObject<PFSubclassing>

@property (strong, nonatomic) Persona *reminderSender;
@property (strong, nonatomic) Persona *reminderReceiver;
@property (strong, nonatomic) NSString *reminderText;
@property (strong, nonatomic) NSDate *reminderSentDate;
@property (strong, nonatomic) NSDate *reminderDueDate;
@property (strong, nonatomic) NSString *dueDateString;

// Make sure this is for the Persona
+ (void) createReminder:(Persona *)receiver text:(NSString *)text dueDate:(NSDate *)dueDate dueDateString:(NSString *)dueDateString withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
