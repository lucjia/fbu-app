//
//  RequestCell.h
//  fbu-app
//
//  Created by jordan487 on 7/19/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Request.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestCell : UITableViewCell

- (void)updateProperties:(Request *)request;

@end

NS_ASSUME_NONNULL_END
