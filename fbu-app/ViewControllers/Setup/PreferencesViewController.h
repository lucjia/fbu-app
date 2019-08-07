//
//  PreferencesViewController.h
//  fbu-app
//
//  Created by lucjia on 7/17/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PreferencesViewControllerDelegate

@end

@interface PreferencesViewController : UIViewController

@property (nonatomic, weak) id<PreferencesViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
