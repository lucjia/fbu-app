//
//  RoommateCell.h
//  fbu-app
//
//  Created by jordan487 on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoommateCell : UITableViewCell

- (void)updateProperties:(PFUser *)user;

@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *bioLabel;

@end

NS_ASSUME_NONNULL_END
