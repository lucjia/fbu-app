//
//  LocationViewController.h
//  fbu-app
//
//  Created by lucjia on 7/17/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationViewControllerDelegate

- (void) setLocationLabelWithLocation:(NSString *)location;

@end

@interface LocationViewController : UIViewController

@property (nonatomic, weak) id<LocationViewControllerDelegate> delegate;

@end
