//
//  Balance.h
//  fbu-app
//
//  Created by sophiakaz on 8/1/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Parse/Parse.h>
#import "Persona.h"

NS_ASSUME_NONNULL_BEGIN

@interface Balance : PFObject

@property (strong, nonatomic) NSArray *housemates;
@property (strong, nonatomic) NSNumber* total;

+ (Balance *) createBalance:(Persona *)housemateOne housemateTwo:(Persona *)housemateTwo totalBalance:(NSNumber *)total withCompletion:(PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
