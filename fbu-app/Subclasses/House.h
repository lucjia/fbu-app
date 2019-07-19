//
//  House.h
//  fbu-app
//
//  Created by sophiakaz on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface House : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *houseID;
@property (nonatomic, strong) NSArray *housemates;
@property (nonatomic, strong) NSArray *rules;
@property (nonatomic, strong) NSArray *reminders;

+ (void) createHouse;
+ (void) addToHouse: (House * _Nullable )house;
+ (void) removeFromHouse;

@end

NS_ASSUME_NONNULL_END
