//
//  LeftCell.m
//  fbu-app
//
//  Created by jordan487 on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "LeftViewCell.h"

@interface LeftViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postSearchTitleLabel;


@end

@implementation LeftViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateProperties:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)updatePostSearchProperties:(NSString *)title {
    self.postSearchTitleLabel.text = title;
}

@end
