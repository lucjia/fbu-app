//
//  HousemateBalanceCell.h
//  fbu-app
//
//  Created by sophiakaz on 8/1/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HousemateBalanceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

NS_ASSUME_NONNULL_END
