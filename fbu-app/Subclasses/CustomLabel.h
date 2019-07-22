//
//  CustomLabel.h
//  fbu-app
//
//  Created by lucjia on 7/22/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomLabel : UILabel

- (UILabel *)styledLabelWithOrigin:(CGPoint)origin text:(NSString *)text textSize:(float)textSize;

@end

NS_ASSUME_NONNULL_END
