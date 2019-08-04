//
//  Balance.m
//  fbu-app
//
//  Created by sophiakaz on 8/1/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "Balance.h"

@implementation Balance

@dynamic housemates;
@dynamic total;

+ (nonnull NSString *)parseClassName {
    return @"Balance";
}

+ (Balance *) createBalance:(Persona *)housemateOne housemateTwo:(Persona *)housemateTwo totalBalance:(NSNumber *)total withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    Balance *newBalance = [Balance objectWithClassName:@"Balance"];
    newBalance.housemates = @[housemateOne,housemateTwo];
    newBalance.total = total;
    [newBalance save];
    for(Persona* housemate in newBalance.housemates){
        [housemate addObject:newBalance forKey:@"balances"];
        [housemate save];
    }
    return  newBalance;
}

+ (void) createAllBalances:(NSArray *)housemates {
    for(int i = 0; i < housemates.count; i++){
        Persona* housemateOne = housemates[i];
        for(int j = i+1; j < housemates.count; j++){
            Persona* housemateTwo = housemates[j];
            [self createBalance:housemateOne housemateTwo:housemateTwo totalBalance:(NSNumber *)0 withCompletion:^(BOOL succeeded, NSError * _Nullable error) { }];
        }
    }
}

- (void) deleteBalance {
    NSArray *housemates = [self objectForKey:@"housemates"];
    [Persona fetchAllIfNeededInBackground:housemates block:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for(Persona *housemate in housemates){
            [housemate removeObject:self forKey:@"balances"];
            [housemate save];
        }
        [self deleteInBackground];
    }];
}

+ (Balance *) getBalance:(Persona *)housemateOne housemateTwo:(Persona *)housemateTwo {
    NSMutableArray *balances = housemateOne.balances;
    [Balance fetchAllIfNeeded:balances];
    for(Balance* balance in balances){
        NSArray *housemates = balance.housemates;
        if([housemates containsObject:housemateOne] && [housemates containsObject:housemateTwo]){
            return balance;
        }
    }
    return nil;
}



@end
