//
//  CustomDatePicker.h
//  fbu-app
//
//  Created by lucjia on 7/27/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomDatePicker : UIPickerView

- (void) initializeDatePickerWithDatePicker:(UIDatePicker *)picker textField:(UITextField *)textField;

- (void) showSelectedDate;

@end

NS_ASSUME_NONNULL_END
