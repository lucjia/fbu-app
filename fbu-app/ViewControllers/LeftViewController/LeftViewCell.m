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
@property (weak, nonatomic) IBOutlet UIImageView *tabImageView;
@property (weak, nonatomic) IBOutlet UIImageView *postSearchImageView;


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
            self.tabImageView.image = [UIImage imageNamed:@"createAHouseW.png"];
            break;
        
        case 1:
            self.tabImageView.image = [UIImage imageNamed:@"houseRulesW.png"];
            break;
            
        case 2:
            self.tabImageView.image = [UIImage imageNamed:@"bulletinBoardW.png"];
            break;
            
        case 3:
            self.tabImageView.image = [UIImage imageNamed:@"calendarW.png"];
            break;
            
        case 4:
            self.tabImageView.image = [UIImage imageNamed:@"remindersW.png"];
            break;
            
        case 5:
            self.tabImageView.image = [UIImage imageNamed:@"sentRemindersW.png"];
            break;
            
        case 6:
            self.tabImageView.image = [UIImage imageNamed:@"progressW.png"];
            break;
            
        case 7:
            self.tabImageView.image = [UIImage imageNamed:@"financeW.png"];
            break;
            
        case 8:
            self.tabImageView.image = [UIImage imageNamed:@"settingsW.png"];
            break;
            
        case 9:
            self.tabImageView.image = [UIImage imageNamed:@"logoutW.png"];
            break;
            
        default:
            break;
    }
    
    self.titleLabel.text = title;
}

- (void)updatePostSearchProperties:(NSString *)title index:(NSInteger)idx {
    switch (idx) {
        case 0:
            self.postSearchImageView.image = [UIImage imageNamed:@"searchW.png"];
            break;
            
        case 1:
            self.postSearchImageView.image = [UIImage imageNamed:@"settingsW.png"];
            break;
            
        case 2:
            self.postSearchImageView.image = [UIImage imageNamed:@"logoutW.png"];
            break;
            
        default:
            break;
    }
    
    if ([title isEqualToString:@" "]) {
        [self setHidden:YES];
    } else {
        self.postSearchTitleLabel.text = title;
    }
}

@end
