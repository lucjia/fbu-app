//
//  RoommateCell.m
//  fbu-app
//
//  Created by jordan487 on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "RoommateCell.h"
#import <Parse/Parse.h>

@interface RoommateCell()


@property (strong, nonatomic) UIImageView *profilePicture;
@property (strong, nonatomic) UIButton *sendRequestButton;

@end

@implementation RoommateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //[self updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@synthesize usernameLabel = _label;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self setUsernameLabel];
        [self setBioLabel];
        [self setProfileImage];
        [self updateConstraints];
    }
    
    return self;
}

- (void)setUsernameLabel {
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 10, self.frame.size.height / 10, 300, 30)];
    self.usernameLabel.textColor = [UIColor blackColor];
    self.usernameLabel.font = [UIFont fontWithName:@"Arial" size:24.0f];
    //[self.usernameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview:self.usernameLabel];
}

- (void)setBioLabel {
    self.bioLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 3, self.frame.size.height, 150, 300)];
    [self.bioLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.bioLabel.textColor = [UIColor blackColor];
    self.bioLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.bioLabel.numberOfLines = 0;
    
    self.bioLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    
    //[self updateConstraints];
    
    [self addSubview:self.bioLabel];
}

- (void)setProfileImage {
    self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 10, 50, 50, 50)];
    
    [self addSubview:self.profilePicture];
}

- (void)updateProperties:(PFUser *)user {
    //username label
    self.usernameLabel.text = [user objectForKey:@"username"];
    self.bioLabel.text = [user objectForKey:@"bio"];
    NSData *imageData = [[user objectForKey:@"profileImage"] getData];
    self.profilePicture.image = [[UIImage alloc] initWithData:imageData];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    // bioLabel constraints
    NSLayoutConstraint *bioLeft = [NSLayoutConstraint constraintWithItem:self.bioLabel
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.usernameLabel
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1.0
                                                             constant:100.0];
    
    NSLayoutConstraint *bioBottom = [NSLayoutConstraint constraintWithItem:self.bioLabel
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                 toItem:self.contentView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:20.0];
    
    NSLayoutConstraint *bioTop = [NSLayoutConstraint constraintWithItem:self.bioLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.contentView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:10.0];
    
    NSLayoutConstraint *bioRight = [NSLayoutConstraint constraintWithItem:self.bioLabel
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.contentView
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:30.0];
    
    // usernameLabel contstraints
    NSLayoutConstraint *usernameLeft = [NSLayoutConstraint constraintWithItem:self.usernameLabel
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.contentView
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:60.0];
    
    NSLayoutConstraint *usernameTop = [NSLayoutConstraint constraintWithItem:self.usernameLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.contentView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:10.0];
    
    [NSLayoutConstraint activateConstraints:@[bioTop, bioLeft, bioRight, bioBottom,
                                              usernameTop, usernameLeft]];
}

@end
