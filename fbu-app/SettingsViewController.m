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
@property (strong, nonatomic) NSArray *userPreferencesArray;
@property (strong, nonatomic) PFGeoPoint *userLocation;
@property (strong, nonatomic) UITextField *userBio;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create Profile image view
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
    [self.profileImageView setImage:[UIImage imageNamed:@""]];
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.profileImageView setTintColor:[UIColor redColor]];
    [self.view addSubview:self.profileImageView];
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
