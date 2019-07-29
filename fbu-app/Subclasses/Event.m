//
//  Event.m
//  fbu-app
//
//  Created by jordan487 on 7/29/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "Event.h"
#import "House.h"

@implementation Event

@dynamic title;
@dynamic memo;
@dynamic isAllDay;
@dynamic location;
@dynamic eventDate;

+ (nonnull NSString *)parseClassName {
    return @"Event";
}

+ (void) createEvent:(NSString *)title eventMemo:(NSString *)memo isAllDay:(BOOL)allDay eventDate:(NSDate *)date withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    Event *newEvent = [Event new];
    newEvent.title = title;
    newEvent.memo = memo;
    newEvent.isAllDay = allDay;
    newEvent.eventDate = date;
    
    [newEvent saveInBackgroundWithBlock:completion];
    
    House *house = [[PFUser currentUser][@"Persona"] objectForKey:@"house"];
    [house fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        [object setObject:newEvent forKey:@"Event"];
    }];
    [house saveInBackgroundWithBlock:completion];
}

@end
