//
//  Request.m
//  fbu-app
//
//  Created by jordan487 on 7/19/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "Request.h"

@implementation Request

@dynamic requestSender;
@dynamic requestReceiver;

+ (nonnull NSString *)parseClassName {
    return @"Request";
}

+ (void) createRequest:(PFUser *)receiver withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    Request *newRequest = [Request new];
    newRequest.requestSender = [PFUser currentUser];
    newRequest.requestReceiver = receiver;
    
    [newRequest saveInBackgroundWithBlock:completion];
}

@end
