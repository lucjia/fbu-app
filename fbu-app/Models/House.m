//
//  House.m
//  fbu-app
//
//  Created by sophiakaz on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "House.h"
#import "Parse/Parse.h"

@implementation House

@dynamic houseID;
@dynamic housemates;
@dynamic rules;
@dynamic reminders;

+ (nonnull NSString *)parseClassName {
    return @"House";
}
\


@end

