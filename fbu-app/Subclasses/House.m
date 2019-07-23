//
//  House.m
//  fbu-app
//
//  Created by sophiakaz on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "House.h"
#import "Parse/Parse.h"

@implementation House

+ (nonnull NSString *)parseClassName {
    return @"House";
}

+ (void) createHouse {
    
    PFUser *user = PFUser.currentUser;
    
    House *house = [House objectWithClassName:@"House"];
    NSMutableArray *housemates =  [[NSMutableArray alloc] init];
    [housemates addObject:user.objectId];
    house[@"housemates"] = housemates;
    [house saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [user setObject:house.objectId forKey:@"houseId"];
        [user saveInBackground];
    }];
}

- (void) addToHouse: (House *)house {
    
    PFUser *user = PFUser.currentUser;
    [self addUniqueObject:user.objectId forKey:@"housemates"];
    [self saveInBackground];
    
    [user setObject:house.objectId forKey:@"houseId"];
    [PFUser.currentUser saveInBackground];
}

- (void) removeFromHouse {
    
    PFUser *user = PFUser.currentUser;
    
    House *house = [self getHouse];
    [house removeObjectsInArray:[NSArray arrayWithObjects:user.objectId, nil] forKey:@"housemates"];
    [house saveInBackground];
    
    [user removeObjectForKey:@"houseId"];
    [user saveInBackground];
}

+ (House *)getHouse {
    PFUser *user = PFUser.currentUser;
    PFQuery *query = [PFQuery queryWithClassName:@"House"];
    [query whereKey:@"objectId" equalTo:[user objectForKey:@"houseId"]];
    [query includeKey:@"housemates"];
    return [query getFirstObject];
}



@end

