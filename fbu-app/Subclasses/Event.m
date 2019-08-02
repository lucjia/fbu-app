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
@dynamic venue;
@dynamic eventDate;
@dynamic eventEndDate;
@dynamic house;

+ (nonnull NSString *)parseClassName {
    return @"Event";
}

+ (Event *) createEvent:(NSString *)title eventMemo:(NSString *)memo isAllDay:(BOOL)allDay eventLocation:(PFGeoPoint *)geo eventVenue:(NSString *)venue eventStartDate:(NSDate *)startDate eventEndDate:(NSDate *)endDate withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    Event *newEvent = [Event new];
    newEvent.title = title;
    newEvent.memo = memo;
    newEvent.isAllDay = allDay;
    if (newEvent.isAllDay) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSCalendarUnitDay |
                                                      NSCalendarUnitMonth |
                                                      NSCalendarUnitYear fromDate:startDate];
        
        [comps setHour:0];
        
        NSDate *date = [calendar dateFromComponents:comps];
        newEvent.eventDate = date;
        
        [comps setHour:24];
        
        date = [calendar dateFromComponents:comps];
        newEvent.eventEndDate = date;
    } else {
        newEvent.eventDate = startDate;
        newEvent.eventEndDate = endDate;
    }
    newEvent.location = geo;
    newEvent.venue = venue;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0.91), ^{
        // switch to a background thread and perform your expensive operation
        Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
        [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            // object for is is SYNCHRONOUS
            House *house = [persona objectForKey:@"house"];
            [house fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                newEvent.house = house;
                [house addEventToHouse:newEvent];
            }];
            [house saveInBackgroundWithBlock:completion];
        }];
        
        [newEvent saveInBackgroundWithBlock:completion];
        dispatch_async(dispatch_get_main_queue(), ^{
            // switch back to the main thread to update your UI
            
        });
    });
    
    return newEvent;
}

- (NSComparisonResult)compare:(Event *)other {
    //Event *otherEvent = (Event *)other;
    return [self.eventDate compare:other.eventDate];
}


@end
