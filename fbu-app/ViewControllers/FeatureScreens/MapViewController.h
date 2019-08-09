//
//  MapViewController.h
//  fbu-app
//
//  Created by lucjia on 8/8/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "BulletinViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController

@property (strong, nonatomic) PFGeoPoint *center;
@property (strong, nonatomic) NSString *poster;
@property (strong, nonatomic) NSString *venue;

@end

NS_ASSUME_NONNULL_END
