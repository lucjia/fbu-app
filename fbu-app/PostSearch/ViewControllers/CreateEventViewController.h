//
//  CreateEventViewController.h
//  fbu-app
//
//  Created by jordan487 on 7/29/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CreateEventViewControllerDelegate

- (void)didCreateEvent:(Event *)event;

@end

@interface CreateEventViewController : UIViewController

@property (nonatomic, weak) id<CreateEventViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
