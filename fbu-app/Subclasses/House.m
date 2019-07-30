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

@implementation House

+ (nonnull NSString *)parseClassName {
    return @"House";
}

+ (void) createHouse: (Persona *) persona {
    
    House *house = [House objectWithClassName:@"House"];
    NSMutableArray *housemates =  [[NSMutableArray alloc] init];
    [housemates addObject:persona];
    house[@"housemates"] = housemates;
    [house save];
    [persona setObject:house forKey:@"house"];
    [persona save];
}


- (void) addToHouse: (Persona *) persona {
    
    House *house = [House getHouse:persona];
    [self addUniqueObject:persona forKey:@"housemates"];
    [self save];
        
    [persona setObject:self forKey:@"house"];
    [persona save];
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
    [self deleteInBackground];
    
}

+ (House *) getHouse: (Persona *) persona {
    House *house = [persona objectForKey:@"house"];
    [house fetchIfNeededInBackground];
    return house;
}



@end

