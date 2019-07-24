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

+ (void) createHouse {
    
    PFUser *user = PFUser.currentUser;
    Persona *persona = [user objectForKey:@"persona"];
    
    House *house = [House objectWithClassName:@"House"];
    NSMutableArray *housemates =  [[NSMutableArray alloc] init];
    [housemates addObject:persona];
    house[@"housemates"] = housemates;
    [house saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [persona setObject:house forKey:@"house"];
        [persona saveInBackground];
    }];
}

- (void) addToHouse {
    
    PFUser *user = PFUser.currentUser;
    Persona *persona = [user objectForKey:@"persona"];
    
    [self addUniqueObject:persona forKey:@"housemates"];
    [self saveInBackground];
    
    [persona setObject:self forKey:@"house"];
    [PFUser.currentUser saveInBackground];
}

- (void) removeFromHouse {
    
    PFUser *user = PFUser.currentUser;
    Persona *persona = [user objectForKey:@"persona"];
    [persona fetchIfNeeded];
    
    [self removeObjectsInArray:[NSArray arrayWithObjects:persona, nil] forKey:@"housemates"];
    [self saveInBackground];
    
    [persona removeObjectForKey:@"house"];
    [persona saveInBackground];
}

- (void) deleteHouse {
    
    [self deleteInBackground];
    
}

+ (House *) getHouse: (PFUser *) user {
    Persona *persona = [user objectForKey:@"persona"];
    [persona fetchIfNeeded];
    House *house = [persona objectForKey:@"house"];
    [house fetchIfNeeded];
    return house;
}



@end

