//
//  Event.h
//  fbu-app
//
//  Created by jordan487 on 7/29/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Parse/Parse.h>
#import "House.h"
@class House;

NS_ASSUME_NONNULL_BEGIN

@interface Event : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *memo;
@property BOOL isAllDay; // is the event an all day event
@property (strong, nonatomic) PFGeoPoint *location; // where the event will occur
@property (strong, nonatomic) NSString *venue; // human readable location
@property (strong, nonatomic) NSDate *eventDate; // when the event will occur
@property (strong, nonatomic) NSDate *eventEndDate; // when the event will occur
@property (strong, nonatomic) House *house; // house the event is associated with

+ (Event *) createEvent:(NSString *)title eventMemo:(NSString *)memo isAllDay:(BOOL)allDay eventLocation:(PFGeoPoint *)geo eventVenue:(NSString *)venue eventStartDate:(NSDate *)startDate eventEndDate:(NSDate *)endDate withCompletion:(PFBooleanResultBlock  _Nullable)completion;
- (NSComparisonResult)compare:(id)other;

@end

NS_ASSUME_NONNULL_END
