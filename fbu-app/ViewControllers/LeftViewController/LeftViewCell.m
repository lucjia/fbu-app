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
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateProperties:(NSString *)title index:(NSInteger)idx {
    switch (idx) {
        case 0:
            self.tabImageView.image = [UIImage imageNamed:@"icons8-home-50"];
            break;
            
        case 1:
            self.tabImageView.image = [UIImage imageNamed:@"icons8-rules-50"];
            break;
            
        case 2:
            self.tabImageView.image = [UIImage imageNamed:@"icons8-pin-50"];
            break;
            
        case 3:
            self.tabImageView.image = [UIImage imageNamed:@"icons8-calendar-50"];
            break;
            
        case 4:
            self.tabImageView.image = [UIImage imageNamed:@"icons8-todo-list-50"];
            break;
            
        case 5:
            self.tabImageView.image = [UIImage imageNamed:@"icons8-paper-plane-50"];
            break;
            
        case 6:
            self.tabImageView.image = [UIImage imageNamed:@"icons8-potted-plant-50"];
            break;
            
        case 7:
            self.tabImageView.image = [UIImage imageNamed:@"icons8-money-box-50"];
            break;
            
        case 8:
            self.tabImageView.image = [UIImage imageNamed:@"icons8-settings-50"];
            break;
            
        case 9:
            self.tabImageView.image = [UIImage imageNamed:@"icons8-exit-50"];
            break;
            
        default:
            break;
    }
    
    self.titleLabel.text = title;
}

- (void)updatePostSearchProperties:(NSString *)title index:(NSInteger)idx {
    switch (idx) {
        case 0:
            self.postSearchImageView.image = [UIImage imageNamed:@"icons8-search-50"];
            break;
            
        case 1:
            self.postSearchImageView.image = [UIImage imageNamed:@"icons8-envelope-50"];
            break;
            
        case 2:
            self.postSearchImageView.image = [UIImage imageNamed:@"icons8-paper-plane-50"];
            break;
            
        case 3:
            self.postSearchImageView.image = [UIImage imageNamed:@"icons8-settings-50"];
            break;
            
        case 4:
            self.postSearchImageView.image = [UIImage imageNamed:@"icons8-exit-50"];
            break;
            
        default:
            break;
    }
    
    self.postSearchTitleLabel.text = title;
}

@end
