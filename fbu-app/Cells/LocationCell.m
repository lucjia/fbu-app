//
//  LocationCell.m
//  fbu-app
//
//  Created by lucjia on 7/18/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "LocationCell.h"
#import "UIImageView+AFNetworking.h"

@interface LocationCell()

@property (strong, nonatomic) NSDictionary *location;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation LocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithLocation:(NSDictionary *)location {
//    self.nameLabel.text = location[@"name"];
//    self.addressLabel.text = [location valueForKeyPath:@"location.address"];
    
    NSArray *categories = location[@"categories"];
    if (categories && categories.count > 0) {
        NSDictionary *category = categories[0];
        NSString *urlPrefix = [category valueForKeyPath:@"icon.prefix"];
        NSString *urlSuffix = [category valueForKeyPath:@"icon.suffix"];
        NSString *urlString = [NSString stringWithFormat:@"%@bg_32%@", urlPrefix, urlSuffix];
        
//        NSURL *url = [NSURL URLWithString:urlString];
//        [self.categoryImageView setImageWithURL:url];
    }
}

@end
