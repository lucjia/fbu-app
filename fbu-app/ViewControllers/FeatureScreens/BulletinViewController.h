//
//  BulletinViewController.h
//  fbu-app
//
//  Created by lucjia on 8/1/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BulletinViewControllerDelegate

- (void) setLocationWithCenter:(PFGeoPoint *)gp poster:(NSString *)poster venue:(NSString *)venue;

@end

@interface BulletinViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<BulletinViewControllerDelegate> delegate;

- (void) fetchPosts;

@end

NS_ASSUME_NONNULL_END
