//
//  LogInViewController.m
//  fbu-app
//
//  Created by lucjia on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "LogInViewController.h"
#import "RegisterViewController.h"
#import "SettingsViewController.h"
#import "Parse/Parse.h"

@interface LogInViewController ()

@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UIButton *logInButton;
@property (strong, nonatomic) UILabel *logInLabel;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUsernameField];
    [self createPasswordField];
    [self createLogInButton];
    [self createLabel];
}

- (void) createUsernameField {
    self.usernameField = [[UITextField alloc] initWithFrame: CGRectMake(80.0f, 240.0f, 215.0f, 30.0f)];
    self.usernameField.delegate = self;
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameField.placeholder = @"Username";
    [self.view addSubview:self.usernameField];
}

- (void) createPasswordField {
    self.passwordField = [[UITextField alloc] initWithFrame: CGRectMake(80.0f, 300.0f, 215.0f, 30.0f)];
    self.passwordField.delegate = self;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
}

- (void) createLogInButton {
    self.logInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.logInButton.frame = CGRectMake(137.5f, 480.0f, 100.0f, 30.0f);
    self.logInButton.backgroundColor = [UIColor lightGrayColor];
    self.logInButton.tintColor = [UIColor whiteColor];
    self.logInButton.layer.cornerRadius = 6;
    self.logInButton.clipsToBounds = YES;
    [self.logInButton addTarget:self action:@selector(logInUser) forControlEvents:UIControlEventTouchUpInside];
    [self.logInButton setTitle:@"Press Me!" forState:UIControlStateNormal];
    [self.view addSubview:self.logInButton];
}

- (void) createLabel {
    self.logInLabel = [[UILabel alloc] initWithFrame:CGRectMake(37.5f, 150.0f, 300.0f, 30.0f)];
    self.logInLabel.text = @"Log In";
    [[self logInLabel] setFont: [UIFont systemFontOfSize:24]];
    self.logInLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.logInLabel];
}

- (void)logInUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        // Display view controller that needs to be shown after successful login
        SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
        // Any setup
        [self presentViewController:settingsVC animated:YES completion:nil];
    }];
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
