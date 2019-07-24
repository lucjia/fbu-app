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

+ (void) createPersona:(NSString * )first lastName:(NSString *)last bio:(NSString *)bio profileImage:(UIImage * _Nullable)image city:(NSString *)city state:(NSString *)state location:(PFGeoPoint *)loc withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    Persona *newPersona = [Persona new];
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

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[Persona class]]) {
        Persona *persona = object;
        return [self.objectId isEqual:persona.objectId];
    } else {
        return NO;
    }
}

@end
