//
//  Persona.h
//  fbu-app
//
//  Created by jordan487 on 7/22/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Parse/Parse.h>
#import "House.h"

NS_ASSUME_NONNULL_BEGIN

@interface Persona : PFObject<PFSubclassing>

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) PFFileObject *profileImage;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) PFGeoPoint *geoPoint;
@property (strong, nonatomic) NSMutableArray *preferences;
@property (strong, nonatomic) House *house;

+ (void) createPersonaWithCompletion:(PFBooleanResultBlock  _Nullable)completion;

+ (void) setPersona:(NSString * )first lastName:(NSString *)last bio:(NSString *)bio profileImage:(UIImage * _Nullable)image city:(NSString *)city state:(NSString *)state location:(PFGeoPoint *)loc withCompletion:(PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
