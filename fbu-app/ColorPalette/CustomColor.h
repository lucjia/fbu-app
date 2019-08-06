//
//  CustomColor.h
//  fbu-app
//
//  Created by jordan487 on 8/5/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomColor : UIView

+ (UIColor *)darkColor:(CGFloat)colorAlpha;
+ (UIColor *)midToneOne:(CGFloat)colorAlpha;
+ (UIColor *)midToneTwo:(CGFloat)colorAlpha;
+ (UIColor *)accentColor:(CGFloat)colorAlpha;

@end

NS_ASSUME_NONNULL_END
