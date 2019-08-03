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
    Balance *newBalance = [Balance new];
    newBalance.housemates = [[NSArray alloc] initWithObjects:housemateOne,housemateTwo];
    newBalance.total = total;
    [newBalance saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        for(Persona* housemate in newBalance.housemates){
            if(housemate.balances == nil){
                housemate.balances = [[NSMutableArray alloc] init];
            }
            [housemate addObject:newBalance forKey:@"balances"];
            [housemate saveInBackground];
        }
    }];
    
    return  newBalance;
}



@end
