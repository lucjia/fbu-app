//
//  LeftCell.h
//  fbu-app
//
//  Created by jordan487 on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeftViewCell : UITableViewCell

- (void)updateProperties:(NSString *)title;
- (void)updatePostSearchProperties:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
