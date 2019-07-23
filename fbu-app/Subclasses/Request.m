//
//  Request.m
//  fbu-app
//
//  Created by jordan487 on 7/19/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "Request.h"
#import "Persona.h"

@implementation Request

@dynamic sender;
@dynamic receiver;

+ (nonnull NSString *)parseClassName {
    return @"Request";
}

+ (void) createRequest:(Persona *)receiver withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    Request *newRequest = [Request new];
    newRequest.sender = [[PFUser currentUser] objectForKey:@"persona"];
    newRequest.receiver = receiver;
    
    [newRequest saveInBackgroundWithBlock:completion];
}

@end
