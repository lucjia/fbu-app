//
//  RegisterViewController.m
//  fbu-app
//
//  Created by lucjia on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "RegisterViewController.h"
#import "SettingsViewController.h"
#import "Parse/Parse.h"
#import "CustomTextField.h"
#import "CustomButton.h"
#import "CustomLabel.h"
#import "Persona.h"

@interface RegisterViewController ()

@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UIButton *registerButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UILabel *registerLabel;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUsernameEmailPasswordFields];
    [self createRegisterButton];
    [self createLabel];
}

- (void) createUsernameEmailPasswordFields {
    CustomTextField *textField = [[CustomTextField alloc] init];
    
    self.usernameField = [textField styledTextFieldWithOrigin:CGPointMake(80, 240) placeholder:@"Username"];
    self.usernameField.delegate = self;
    [self.view addSubview:self.usernameField];
    
    self.emailField = [textField styledTextFieldWithOrigin:CGPointMake(80, 300) placeholder:@"Email"];
    self.emailField.delegate = self;
    [self.view addSubview:self.emailField];
    
    self.passwordField = [textField styledTextFieldWithOrigin:CGPointMake(80, 360) placeholder:@"Password"];
    self.passwordField.delegate = self;
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
}

- (void) createRegisterButton {
    CustomButton *button = [[CustomButton alloc] init];
    self.registerButton = [button styledBackgroundButtonWithOrigin:CGPointMake(150, 420) text:@"Register User"];
    [self.registerButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
    
    self.backButton = [button styledBackgroundButtonWithOrigin:CGPointMake(150, 500) text:@"Back to Log In"];
    [self.backButton addTarget:self action:@selector(segueToLogIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
}

- (void) createLabel {
    CustomLabel *label = [[CustomLabel alloc] init];
    self.registerLabel = [label styledLabelWithOrigin:CGPointMake(80, 120) text:@"Register New User" textSize:24];
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
            alert.view.tintColor = [UIColor redColor];
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
        [self performSegueWithIdentifier:@"toSettings" sender:self];
    }];
}

- (void)segueToLogIn {
    [self dismissViewControllerAnimated:YES completion:nil];
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
