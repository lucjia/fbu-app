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

@class House;

@interface Persona : PFObject<PFSubclassing>

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) PFFileObject *profileImage;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *city; // city they are looking for roommates in
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) PFGeoPoint *geoPoint; // longitude and latitude
@property (strong, nonatomic) NSMutableArray *preferences;
@property (strong, nonatomic) House *house;
@property (strong, nonatomic) NSMutableArray *requestsSent; // by the user
@property (strong, nonatomic) NSMutableArray *requestsReceived; // to the user
@property (strong, nonatomic) NSMutableArray *acceptedRequests;

+ (void) createPersonaUponRegistrationWithCompletion:(PFBooleanResultBlock _Nullable)completion;

+ (void) createPersona:(NSString * )first lastName:(NSString *)last bio:(NSString *)bio profileImage:(UIImage * _Nullable)image city:(NSString *)city state:(NSString *)state location:(PFGeoPoint *)loc withCompletion:(PFBooleanResultBlock  _Nullable)completion;

+ (void) initializeArrayPropertiesWithPersona:(Persona *)persona;

@end

NS_ASSUME_NONNULL_END
