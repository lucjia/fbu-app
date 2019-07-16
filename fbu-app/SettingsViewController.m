//
//  SettingsViewController.m
//  fbu-app
//
//  Created by lucjia on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "SettingsViewController.h"
#import "Parse/Parse.h"

@interface SettingsViewController ()

@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UIButton *changeProfileButton;
@property (strong, nonatomic) NSArray *userPreferencesArray;
@property (strong, nonatomic) PFGeoPoint *userLocation;
@property (strong, nonatomic) UITextField *userBio;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create Profile image view
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(127.5f, 100, 120, 120)];
//    [self.profileImageView setImage:[UIImage imageNamed:@""]];
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.profileImageView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.profileImageView];
    
    // Create Change Profile button
    self.changeProfileButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.changeProfileButton.frame = CGRectMake(137.5f, 240, 100.0f, 30.0f);
    self.changeProfileButton.backgroundColor = [UIColor lightGrayColor];
    self.changeProfileButton.tintColor = [UIColor whiteColor];
    self.changeProfileButton.layer.cornerRadius = 6;
    self.changeProfileButton.clipsToBounds = YES;
    [self.changeProfileButton addTarget:self action:@selector(changeProfilePicture) forControlEvents:UIControlEventTouchUpInside];
    [self.changeProfileButton setTitle:@"Change Profile Picture" forState:UIControlStateNormal];
    [self.view addSubview:self.changeProfileButton];
}

// Dismiss keyboard after typing
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
