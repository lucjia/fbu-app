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
#import <Parse/Parse.h>

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

+ (void) createPersona:(NSString * )first lastName:(NSString *)last bio:(NSString *)bio profileImage:(UIImage * _Nullable)image city:(NSString *)city state:(NSString *)state location:(PFGeoPoint *)loc withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    Persona *newPersona;
    
    if ([[PFUser currentUser] objectForKey:@"persona"] == nil) {
        newPersona = [Persona new];
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
    newPersona.preferences = [[NSMutableArray alloc] init];
    newPersona.requestsSent = [[NSMutableArray alloc] init];
    newPersona.requestsReceived = [[NSMutableArray alloc] init];
    newPersona.acceptedRequests = [[NSMutableArray alloc] init];
    
    [[PFUser currentUser] setObject:newPersona forKey:@"persona"];
    
    [newPersona saveInBackgroundWithBlock:completion];
    [[PFUser currentUser] saveInBackgroundWithBlock:completion];
}

- (void) updatePreferences:(NSArray *)preferences {
    self.preferences = [NSMutableArray arrayWithArray:preferences];
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

+ (UIImage *)getImageFromPFFile:(PFFileObject *)file {
    NSData *data = [file getData];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[Persona class]]) {
        Persona *persona = object;
        return [self.objectId isEqual:persona.objectId];
    } else {
        return NO;
    }
}

- (void)addToAcceptedRequests:(Persona *)persona {
    if (self.acceptedRequests == nil) {
        self.acceptedRequests = [NSMutableArray new];
    }
    if (persona.acceptedRequests == nil) {
        persona.acceptedRequests = [NSMutableArray new];
    }
    
    [self saveInBackground];
    [persona saveInBackground];
    
    [self queryPersonaUpdateArrayKey:persona.objectId keyToUpdate:@"acceptedRequests" valueForKey:persona.acceptedRequests valueInArray:self];
    
    [self queryPersonaUpdateArrayKey:self.objectId keyToUpdate:@"acceptedRequests" valueForKey:self.acceptedRequests valueInArray:persona];
}

// makes a query for a persona object with the matching objectId
// inserts an object (arrValue) into the array (value) for the key (key)
- (void)queryPersonaUpdateArrayKey:(NSString *)objectId keyToUpdate:(NSString *)key valueForKey:(id)value valueInArray:(id)arrValue {
    // Create the PFQuery
    PFQuery *query = [PFQuery queryWithClassName:@"Persona"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *pfobject, NSError *error) {

        Persona *persona = (Persona *)pfobject;
        [value insertObject:arrValue atIndex:0];
        [persona setObject:value forKey:key];
        [persona saveInBackground];
    }];
}

@end
