//
//  RegisterViewController.m
//  fbu-app
//
//  Created by lucjia on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "RegisterViewController.h"
#import "Parse/Parse.h"

@interface RegisterViewController ()

@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UIButton *registerButton;
@property (strong, nonatomic) UILabel *registerLabel;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create username field
    self.usernameField = [[UITextField alloc] initWithFrame: CGRectMake(80.0f, 240.0f, 215.0f, 30.0f)];
    self.usernameField.delegate = self;
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameField.placeholder = @"Username";
    [self.view addSubview:self.usernameField];
    
    // Create email field
    self.emailField = [[UITextField alloc] initWithFrame: CGRectMake(80.0f, 300.0f, 215.0f, 30.0f)];
    self.emailField.delegate = self;
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailField.placeholder = @"Email";
    [self.view addSubview:self.emailField];
    
    // Create password field
    self.passwordField = [[UITextField alloc] initWithFrame: CGRectMake(80.0f, 360.0f, 215.0f, 30.0f)];
    self.passwordField.delegate = self;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
    
    // Create register button
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.frame = CGRectMake(137.5f, 480.0f, 100.0f, 30.0f);
    self.registerButton.backgroundColor = [UIColor lightGrayColor];
    self.registerButton.tintColor = [UIColor whiteColor];
    self.registerButton.layer.cornerRadius = 6;
    self.registerButton.clipsToBounds = YES;
    [self.registerButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [self.registerButton setTitle:@"Press Me!" forState:UIControlStateNormal];
    [self.view addSubview:self.registerButton];
    
    // Create label
    self.registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(37.5f, 150.0f, 300.0f, 30.0f)];
    self.registerLabel.text = @"Register New User";
    [[self registerLabel] setFont: [UIFont systemFontOfSize:24]];
    self.registerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.registerLabel];
}

- (void)registerUser {
    // Initialize a user object
    PFUser *newUser = [PFUser user];
    
    // Set user properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    // Call sign up function on user
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error != nil) {
            // Create alert to display error
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Register"
                                                                           message:@"Invalid username, email, or password."
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            // Create a try again action
            UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      // Handle cancel response here. Doing nothing will dismiss the view.
                                                                  }];
            // Add the cancel action to the alertController
            [alert addAction:dismissAction];
            alert.view.tintColor = [UIColor whiteColor];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            // User registered successfully, automatically log in
            [self logInUser];
        }
    }];
}

// Dismiss keyboard after typing
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)logInUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        // Display view controller that needs to be shown after successful login
//        HomeViewController *homeVC = [[HomeViewController alloc] init];
//        // Any setup
//        [self presentModalViewController:homeVC animated:YES];
    }];
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
