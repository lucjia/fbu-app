//
//  UserCollectionCell.m
//  fbu-app
//
//  Created by lucjia on 7/29/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "UserCollectionCell.h"

@implementation UserCollectionCell

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
    self.profileView.layer.cornerRadius = self.frame.size.width / 2.0;
    self.profileView.layer.masksToBounds = YES;
    self.profileView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
