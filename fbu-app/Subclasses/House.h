//
//  House.h
//  fbu-app
//
//  Created by sophiakaz on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Persona.h"

NS_ASSUME_NONNULL_BEGIN

@interface House : PFObject<PFSubclassing>


+ (void) createHouse;
- (void) addToHouse: (Persona *) persona;
- (void) removeFromHouse: (Persona *) persona;
+ (House *) getHouse: (Persona *) persona;
- (void) deleteHouse;

@end

NS_ASSUME_NONNULL_END
