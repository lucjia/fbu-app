//
//  Bill.h
//  fbu-app
//
//  Created by sophiakaz on 8/4/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Parse/Parse.h>
#import "House.h"
#import "Persona.h"

NS_ASSUME_NONNULL_BEGIN

@interface Bill : PFObject<PFSubclassing>

@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) Persona *payer;
@property (strong, nonatomic) NSArray *debtors;
@property (strong, nonatomic) NSArray *portions;
@property (strong, nonatomic) PFFileObject *image;
@property (strong, nonatomic) NSString *memo;
@property (strong, nonatomic) NSDecimalNumber *paid;

+ (Bill *) createBill:(NSDate *)date billMemo:(NSString *)memo payer:(Persona*)payer totalPaid:(NSDecimalNumber *)paid debtors:(NSArray *)debtors portionLent:(NSArray*)portions image:(UIImage * _Nullable)image withCompletion:(PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
