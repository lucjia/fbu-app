//
//  CustomTextField.h
//  fbu-app
//
//  Created by lucjia on 7/22/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTextField : UITextField

- (UITextField *)styledTextFieldWithOrigin:(CGPoint)origin placeholder:(NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END
