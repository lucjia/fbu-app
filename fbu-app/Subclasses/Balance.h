//
//  Balance.h
//  fbu-app
//
//  Created by sophiakaz on 8/1/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Parse/Parse.h>
#import "Persona.h"
#import "Bill.h"

NS_ASSUME_NONNULL_BEGIN

@interface Balance : PFObject<PFSubclassing>

@property (strong, nonatomic) NSArray *housemates;
@property (strong, nonatomic) NSDecimalNumber * total;
@property (strong, nonatomic) NSMutableArray *bills;

+ (Balance *) createBalance:(Persona *)housemateOne housemateTwo:(Persona *)housemateTwo totalBalance:(NSDecimalNumber *)total withCompletion:(PFBooleanResultBlock  _Nullable)completion;
- (void) deleteBalance;
+ (Balance *) getBalance:(Persona *)housemateOne housemateTwo:(Persona *)housemateTwo;
- (void) updateBalance:(Bill*)bill indexOfDebtor:(int)index;
- (void) updateBalanceDeleteBill:(Bill*)bill indexOfDebtor:(int)index;

@end

NS_ASSUME_NONNULL_END
