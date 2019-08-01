//
//  House.m
//  fbu-app
//
//  Created by sophiakaz on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "House.h"
#import "Parse/Parse.h"
#import "Persona.h"
#import "Event.h"

@implementation House

@dynamic events;

+ (nonnull NSString *)parseClassName {
    return @"House";
}

+ (void) createHouse: (Persona *) persona {
    
    House *house = [House objectWithClassName:@"House"];
    NSMutableArray *housemates =  [[NSMutableArray alloc] init];
    [housemates addObject:persona];
    house[@"housemates"] = housemates;
    if (!house.events) {
        house.events = [[NSMutableArray alloc] init];
    }
    [house saveInBackground];
    [persona setObject:house forKey:@"house"];
    [persona saveInBackground];
}


- (void) addToHouse: (Persona *) persona {
    
    House *house = [House getHouse:persona];
    [self addUniqueObject:persona forKey:@"housemates"];
    [self saveInBackground];
    
    [persona setObject:self forKey:@"house"];
    [persona saveInBackground];
}


- (void) removeFromHouse: (Persona *) persona {
    
    [self removeObject:persona forKey:@"housemates"];
    [self saveInBackground];
    
    [persona removeObjectForKey:@"house"];
    [persona saveInBackground];
}

- (void) deleteHouse {
    NSArray *housemates = [self objectForKey:@"housemates"];
    for(Persona *housemate in housemates){
        [self removeFromHouse:housemate];
    }
    [self delete];
    
}

+ (House *) getHouse: (Persona *) persona {
    House *house = [persona objectForKey:@"house"];
    [house fetchIfNeeded];
    return house;
}

- (void)addEventToHouse:(Event *)event {
    [self.events insertObject:event atIndex:0];
    [self setObject:self.events forKey:@"events"];
    [self saveInBackground];
}

@end

