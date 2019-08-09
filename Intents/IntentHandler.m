//
//  IntentHandler.m
//  Intents
//
//  Created by lucjia on 8/8/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "IntentHandler.h"
#import "CreateReminderIntent.h"

@interface IntentHandler () <CreateReminderIntentHandling>

@end

@implementation IntentHandler

- (void)handleCreateReminder:(nonnull CreateReminderIntent *)intent completion:(nonnull void (^)(CreateReminderIntentResponse * _Nonnull))completion {
    // Do something...
    NSLog(@"HI");
    
    // Send response
    CreateReminderIntentResponse* response = [[CreateReminderIntentResponse alloc] initWithCode:CreateReminderIntentResponseCodeSuccess userActivity:nil];
    completion(response);
}

@end
