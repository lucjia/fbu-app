//
//  House.h
//  fbu-app
//
//  Created by sophiakaz on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Persona.h"
#import "Event.h"

@class Event;

NS_ASSUME_NONNULL_BEGIN

@class Persona;

@interface House : PFObject<PFSubclassing>

@property (strong, nonatomic) NSMutableArray *events;

+ (void)createHouse:(Persona *)persona;
- (void)addToHouse:(Persona *)persona;
- (void)removeFromHouse:(Persona *)persona;
+ (House *)getHouse:(Persona *)persona;
- (void) deleteHouse;
- (void)addEventToHouse:(Event *)event;

@end

NS_ASSUME_NONNULL_END
