//
//  User.m
//  fbu-app
//
//  Created by jordan487 on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic username;
@dynamic bio;

+ (nonnull NSString *)parseClassName {
    return @"User"; 
}

@end
