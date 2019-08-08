//
//  ComposePostViewController.h
//  fbu-app
//
//  Created by lucjia on 8/5/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ComposePostViewControllerDelegate

- (void) refresh;

@end

@interface ComposePostViewController : UIViewController

@property (nonatomic, weak) id<ComposePostViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
