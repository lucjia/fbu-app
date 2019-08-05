//
//  Post.m
//  fbu-app
//
//  Created by lucjia on 8/5/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "Post.h"
#import "Persona.h"

@implementation Post

@dynamic postSender;
@dynamic postText;
@dynamic location;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) createPostWithSender:(Persona *)sender text:(NSString *)text withCompletion:(PFBooleanResultBlock _Nullable)completion {
    Post *newPost = [Post new];
    newPost.postSender = sender;
    newPost.postText = text;
    
    [newPost saveInBackgroundWithBlock:completion];
}

+ (void) createPostWithSender:(Persona *)sender text:(NSString *)text location:(PFGeoPoint *)location withCompletion:(PFBooleanResultBlock _Nullable)completion {
    Post *newPost = [Post new];
    newPost.postSender = sender;
    newPost.postText = text;
    newPost.location = location;
    
    [newPost saveInBackgroundWithBlock:completion];
}

@end
