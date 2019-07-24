//
//  Request.h
//  fbu-app
//
//  Created by jordan487 on 7/19/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Parse/Parse.h>
#import "Persona.h"

NS_ASSUME_NONNULL_BEGIN

@interface Request : PFObject<PFSubclassing>

@property (strong, nonatomic) Persona *sender;
@property (strong, nonatomic) Persona *receiver;

+ (void) createRequest:(Persona *)receiver withCompletion:(PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
