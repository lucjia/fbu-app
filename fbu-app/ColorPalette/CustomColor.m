//
//  CustomColor.m
//  fbu-app
//
//  Created by jordan487 on 8/5/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CustomColor.h"

@implementation CustomColor

+ (UIColor *)lightyellowGreen:(CGFloat)colorAlpha {
    return [UIColor colorWithRed:(251 / 255.0) green:(250 / 255.0) blue:(211 / 255.0) alpha:colorAlpha];
}

+ (UIColor *)lightGreen:(CGFloat)colorAlpha {
    return [UIColor colorWithRed:(198 / 255.0) green:(277 / 255.0) blue:(119 / 255.0) alpha:colorAlpha];
}

+ (UIColor *)Green:(CGFloat)colorAlpha {
    return [UIColor colorWithRed:(114 / 255.0) green:(157 / 255.0) blue:(57 / 255.0) alpha:colorAlpha];
}

+ (UIColor *)DarkGreen:(CGFloat)colorAlpha {
    return [UIColor colorWithRed:(54 / 255.0) green:(98 / 255.0) blue:(43 / 255.0) alpha:colorAlpha];
}

@end
