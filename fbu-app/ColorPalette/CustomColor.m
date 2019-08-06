//
//  CustomColor.m
//  fbu-app
//
//  Created by jordan487 on 8/5/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CustomColor.h"

@implementation CustomColor

+ (UIColor *)darkMainColor:(CGFloat)colorAlpha {
    return [UIColor colorWithRed:(4 / 255.0) green:(47 / 255.0) blue:(75 / 255.0) alpha:colorAlpha];
}

+ (UIColor *)midToneOne:(CGFloat)colorAlpha {
    return [UIColor colorWithRed:(255 / 255.0) green:(246 / 255.0) blue:(218 / 255.0) alpha:colorAlpha];
}

+ (UIColor *)midToneTwo:(CGFloat)colorAlpha {
    return [UIColor colorWithRed:(251 / 255.0) green:(201 / 255.0) blue:(157 / 255.0) alpha:colorAlpha];
}

+ (UIColor *)accentColor:(CGFloat)colorAlpha {
    return [UIColor colorWithRed:(237 / 255.0) green:(18 / 255.0) blue:(80 / 255.0) alpha:colorAlpha];
}

+ (UIColor *)lightGrey:(CGFloat)colorAlpha {
    return [UIColor colorWithRed:(111 / 255.0) green: (113 / 255.0) blue:(121 / 255.0) alpha:colorAlpha];
}

@end
