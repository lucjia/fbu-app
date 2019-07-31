//
//  EventLocationViewController.h
//  fbu-app
//
//  Created by jordan487 on 7/31/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "LocationViewController.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EventLocationViewControllerDelegate

- (void)didSetLocation:(NSString *)location;

@end


@interface EventLocationViewController : LocationViewController

@property (nonatomic, weak) id<EventLocationViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
