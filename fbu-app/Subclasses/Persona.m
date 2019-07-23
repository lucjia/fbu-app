//
//  Persona.m
//  fbu-app
//
//  Created by jordan487 on 7/22/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

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

+ (nonnull NSString *)parseClassName {
    return @"Persona";
}

/*
 --TO DO--
 Update Preferences
 send and receive requests
 */

+ (void) createPersonaWithCompletion:(PFBooleanResultBlock  _Nullable)completion {
    Persona *newPersona = [Persona new];
    newPersona.user = [PFUser currentUser];
    [[PFUser currentUser] setObject:newPersona forKey:@"persona"];
    
    [newPersona saveInBackgroundWithBlock:completion];
    [[PFUser currentUser] saveInBackgroundWithBlock:completion];
}

+ (void) setPersona:(NSString *)first lastName:(NSString *)last bio:(NSString *)bio profileImage:(UIImage * _Nullable)image city:(NSString *)city state:(NSString *)state location:(PFGeoPoint *)loc withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    Persona *updatedPersona = [PFUser currentUser][@"persona"];
    updatedPersona.user = [PFUser currentUser];
    updatedPersona.username = [PFUser currentUser][@"username"];
    updatedPersona.firstName = first;
    updatedPersona.lastName = last;
    updatedPersona.bio = bio;
    updatedPersona.profileImage = [self getPFFileFromImage:image];
    updatedPersona.city = city;
    updatedPersona.state = state;
    updatedPersona.geoPoint = loc;
    updatedPersona.preferences = [[NSMutableArray alloc] init];
    
    [[PFUser currentUser][@"persona"] setObject:updatedPersona forKey:@"persona"];
    
    [updatedPersona saveInBackgroundWithBlock:completion];
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

@end
