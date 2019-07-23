//
//  CustomTextField.m
//  fbu-app
//
//  Created by lucjia on 7/22/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (UITextField *)styledTextFieldWithOrigin:(CGPoint)origin placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(origin.x, origin.y, 250, 30)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = placeholder;
    return textField;
}

@end
