//
//  LocationViewController.h
//  fbu-app
//
//  Created by lucjia on 7/17/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol LocationViewControllerDelegate

- (void)locationViewController:(LocationViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;

@end

@interface LocationViewController : UIViewController

@property (weak, nonatomic) id<LocationViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
