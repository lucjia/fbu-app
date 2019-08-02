//
//  DetailsViewController.h
//  fbu-app
//
//  Created by jordan487 on 7/18/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Persona.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) Persona *user;

+ (void)createAlertController:(NSString *)title message:(NSString *)msg sender:(id)sender;

@end

NS_ASSUME_NONNULL_END
