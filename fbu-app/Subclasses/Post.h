//
//  Post.h
//  fbu-app
//
//  Created by lucjia on 8/5/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Persona.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (strong, nonatomic) Persona *postSender;
@property (strong, nonatomic) NSString *postText;
@property (strong, nonatomic) PFGeoPoint *location;

+ (void) createPostWithSender:(Persona *)sender text:(NSString *)text withCompletion:(PFBooleanResultBlock _Nullable)completion;

+ (void) createPostWithSender:(Persona *)sender text:(NSString *)text location:(PFGeoPoint *)location withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
