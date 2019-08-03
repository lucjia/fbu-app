//
//  EventDetailsViewController.h
//  fbu-app
//
//  Created by jordan487 on 8/2/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventDetailsViewController : UIViewController

@property (strong, nonatomic) Event *event;

- (void)updateProperties:(Event *)event;

@end

NS_ASSUME_NONNULL_END
