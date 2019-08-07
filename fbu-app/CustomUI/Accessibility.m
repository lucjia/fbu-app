//
//  Accessibility.m
//  fbu-app
//
//  Created by lucjia on 8/7/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "Accessibility.h"

@implementation Accessibility

+ (void) largeTextCompatibilityWithLabel:(UILabel *)label style:(NSString *)style {
    label.font = [UIFont preferredFontForTextStyle:style];
    label.adjustsFontForContentSizeCategory = YES;
}

+ (void) largeTextCompatibilityWithField:(UITextField *)field style:(NSString *)style {
    field.font = [UIFont preferredFontForTextStyle:style];
    field.adjustsFontForContentSizeCategory = YES;
}

+ (void) largeTextCompatibilityWithView:(UITextView *)view style:(NSString *)style {
    view.font = [UIFont preferredFontForTextStyle:style];
    view.adjustsFontForContentSizeCategory = YES;
}

@end
