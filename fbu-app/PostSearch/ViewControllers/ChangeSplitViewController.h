//
//  ChangeSplitViewController.h
//  fbu-app
//
//  Created by sophiakaz on 8/5/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Persona.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChangeSplitViewControllerDelegate
- (void)changeSplit:(Persona *)payer debtors:(NSMutableArray*)debtors portions:(NSMutableArray*)portions;
@end

@interface ChangeSplitViewController : UIViewController
- (IBAction)tapSave:(id)sender;

@property (nonatomic, weak) id<ChangeSplitViewControllerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
