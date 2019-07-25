//
//  Persona.m
//  fbu-app
//
//  Created by jordan487 on 7/22/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

/*
 The purpose of this class is to allow for a reference to the user
 to be maintained without directly including any sensitive information
 */

#import "Persona.h"
#import "House.h"

@implementation Persona

@dynamic user;
@dynamic username;
@dynamic firstName;
@dynamic lastName;
@dynamic bio;
@dynamic profileImage;
@dynamic city;
@dynamic state;
@dynamic geoPoint;
@dynamic preferences;
@dynamic house;
@dynamic requestsSent;
@dynamic requestsReceived;
@dynamic acceptedRequests;

+ (nonnull NSString *)parseClassName {
    return @"Persona";
}

/*
 --TO DO--
 Update Preferences
 send and receive requests
 */

+ (void) createPersonaUponRegistrationWithCompletion:(PFBooleanResultBlock _Nullable)completion {
    Persona *newRegisterPersona = [Persona new];
    // Initialize some properties which are later set elsewhere
    [self initializeArrayPropertiesWithPersona:newRegisterPersona];
    
    [[PFUser currentUser] setObject:newRegisterPersona forKey:@"persona"];
    [newRegisterPersona saveInBackgroundWithBlock:completion];
    [[PFUser currentUser] saveInBackgroundWithBlock:completion];
}

+ (void) createPersona:(NSString * )first lastName:(NSString *)last bio:(NSString *)bio profileImage:(UIImage * _Nullable)image city:(NSString *)city state:(NSString *)state location:(PFGeoPoint *)loc withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    Persona *newPersona;
    
    if ([[PFUser currentUser] objectForKey:@"persona"] == nil) {
        newPersona = [Persona new];
        
        // Initialize some properties which are later set elsewhere
        [self initializeArrayPropertiesWithPersona:newPersona];
    } else {
        newPersona = [[PFUser currentUser] objectForKey:@"persona"];
    }
    
    newPersona.user = [PFUser currentUser];
    newPersona.username = [PFUser currentUser][@"username"];
    newPersona.firstName = first;
    newPersona.lastName = last;
    newPersona.bio = bio;
    newPersona.profileImage = [self getPFFileFromImage:image];
    newPersona.city = city;
    newPersona.state = state;
    newPersona.geoPoint = loc;
    
    [[PFUser currentUser] setObject:newPersona forKey:@"persona"];
    
    [newPersona saveInBackgroundWithBlock:completion];
    [[PFUser currentUser] saveInBackgroundWithBlock:completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[Persona class]]) {
        Persona *persona = object;
        return [self.objectId isEqual:persona.objectId];
    } else {
        return NO;
    }
}

+ (void) initializeArrayPropertiesWithPersona:(Persona *)persona {
    persona.preferences = [[NSMutableArray alloc] init];
    persona.requestsSent = [[NSMutableArray alloc] init];
    persona.requestsReceived = [[NSMutableArray alloc] init];
    persona.acceptedRequests = [[NSMutableArray alloc] init];
}

@end
