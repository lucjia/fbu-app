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
#import "Balance.h"

@implementation House

@dynamic events;
@dynamic rules;
@dynamic housemates;

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
    [house save];
    [persona setObject:house forKey:@"house"];
    [persona save];
    
}


- (void) addToHouse: (Persona *) persona {
    NSArray *housemates = [self objectForKey:@"housemates"];
    [Persona fetchAllIfNeededInBackground:housemates block:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for(Persona* housemate in housemates){
            [Balance createBalance:persona housemateTwo:housemate totalBalance:[NSDecimalNumber zero] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {}];
        }
    }];
    [self addUniqueObject:persona forKey:@"housemates"];
    [self save];
    
    [persona setObject:self forKey:@"house"];
    [persona save];

}

- (void) removeFromHouse: (Persona *) persona {
    NSArray *balances = persona.balances;
    [Balance fetchAllIfNeededInBackground:balances block:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for(Balance *balance in balances){
            [balance deleteBalance];
        }
    }];
    
    [self removeObject:persona forKey:@"housemates"];
    [self save];
    
    [persona removeObjectForKey:@"house"];
    [persona save];
    
}

- (void) deleteHouse {
    NSArray *housemates = [self objectForKey:@"housemates"];
    for(Persona *housemate in housemates){
        [self removeFromHouse:housemate];
        
    }
    [self deleteInBackground];
    
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

