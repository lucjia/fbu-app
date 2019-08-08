//
//  CustomLabel.m
//  fbu-app
//
//  Created by lucjia on 7/22/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (UILabel *)styledLabelWithOrigin:(CGPoint)origin text:(NSString *)text textSize:(float)textSize {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(origin.x, origin.y, 250, 30)];
    label.text = text;
    [label setFont: [UIFont systemFontOfSize:textSize]];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
