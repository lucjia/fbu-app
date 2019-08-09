//
//  ProgressViewController.h
//  fbu-app
//
//  Created by lucjia on 7/31/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ProgressViewControllerDelegate

- (void) setIndexWithIndex:(NSInteger)index;

@end

@interface ProgressViewController : UIViewController

@property (nonatomic, weak) id<ProgressViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger lastIndex;

@end

NS_ASSUME_NONNULL_END
