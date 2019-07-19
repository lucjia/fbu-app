//
//  Request.h
//  fbu-app
//
//  Created by jordan487 on 7/19/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Request : PFObject<PFSubclassing>

@property (strong, nonatomic) PFUser *requestSender;
@property (strong, nonatomic) PFUser *requestReceiver;

+ (void) createRequest:(PFUser *)receiver withCompletion:(PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
