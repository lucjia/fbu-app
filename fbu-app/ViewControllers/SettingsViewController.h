//
//  SettingsViewController.h
//  fbu-app
//
//  Created by lucjia on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingsViewController : UIViewController <UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImage *resizedImage;
@property (strong, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END
