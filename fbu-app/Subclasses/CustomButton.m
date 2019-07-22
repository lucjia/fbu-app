//
//  CustomButton.m
//  fbu-app
//
//  Created by lucjia on 7/22/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (UIButton *)styledBackgroundButtonWithOrigin:(CGPoint)origin text:(NSString *)text {
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor lightGrayColor];
    button.tintColor = [UIColor whiteColor];
    button.layer.cornerRadius = 6;
    button.clipsToBounds = YES;
    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 1;
    [button sizeToFit];
    button.frame = CGRectMake(origin.x, origin.y, button.intrinsicContentSize.width + 12, 30);
    return button;
}

@end
