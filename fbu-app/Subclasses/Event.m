//
//  Event.m
//  fbu-app
//
//  Created by jordan487 on 7/29/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "Event.h"
#import "House.h"
#import "Persona.h"

@implementation Event

@dynamic title;
@dynamic memo;
@dynamic isAllDay;
@dynamic location;
@dynamic eventDate;
@dynamic house;

+ (nonnull NSString *)parseClassName {
    return @"Event";
}

+ (void) createEvent:(NSString *)title eventMemo:(NSString *)memo isAllDay:(BOOL)allDay eventDate:(NSDate *)date withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    Event *newEvent = [Event new];
    newEvent.title = title;
    newEvent.memo = memo;
    newEvent.isAllDay = allDay;
    newEvent.eventDate = date;
    
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeededInBackground];
    House *house = [persona objectForKey:@"house"];
    [house fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        [house addEventToHouse:newEvent];
        newEvent.house = house;
    }];
    
    [newEvent saveInBackgroundWithBlock:completion];
    [house saveInBackgroundWithBlock:completion];
}


@end
