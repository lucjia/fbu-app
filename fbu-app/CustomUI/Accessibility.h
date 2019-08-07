//
//  Accessibility.h
//  fbu-app
//
//  Created by lucjia on 8/7/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Accessibility : NSObject

+ (void) largeTextCompatibilityWithLabel:(UILabel *)label style:(NSString *)style;

+ (void) largeTextCompatibilityWithField:(UITextField *)field style:(NSString *)style;

+ (void) largeTextCompatibilityWithView:(UITextView *)view style:(NSString *)style;

@end

NS_ASSUME_NONNULL_END
