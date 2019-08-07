//
//  Accessibility.m
//  fbu-app
//
//  Created by lucjia on 8/7/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "Accessibility.h"

@implementation Accessibility

+ (void) largeTextCompatibilityWithLabel:(UILabel *)label {
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label.adjustsFontForContentSizeCategory = YES;
}

+ (void) largeTextCompatibilityWithField:(UITextField *)field {
    field.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    field.adjustsFontForContentSizeCategory = YES;
}

+ (void) largeTextCompatibilityWithView:(UITextView *)view {
    view.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    view.adjustsFontForContentSizeCategory = YES;
}

@end
