//
//  DebtorCell.h
//  fbu-app
//
//  Created by sophiakaz on 8/9/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DebtorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *owesLabel;
@property (weak, nonatomic) IBOutlet UILabel *portionLabel;
@property (weak, nonatomic) IBOutlet UILabel *extraTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *extraMoneyLabel;

@end

NS_ASSUME_NONNULL_END
