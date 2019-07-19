//
//  User.h
//  fbu-app
//
//  Created by jordan487 on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Parse/Parse.h>
#import "House.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *bio;

@end


NS_ASSUME_NONNULL_END
