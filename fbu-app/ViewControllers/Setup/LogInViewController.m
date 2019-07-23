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
#import "TimelineViewController.h"
#import "Parse/Parse.h"
#import "CustomButton.h"

@interface LogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *logInLabel;
@property (strong, nonatomic) UIButton *logInButton;
@property (strong, nonatomic) UIButton *registerButton;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUsernameField];
    [self createPasswordField];
    [self createLogInRegisterButtons];
    [self createLabel];
}

- (void) createUsernameField {
    self.usernameField.delegate = self;
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameField.placeholder = @"Username";
}

- (void) createPasswordField {
    self.passwordField.delegate = self;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
}

- (void) createLogInRegisterButtons {
    CustomButton *button = [[CustomButton alloc] init];
    self.logInButton = [button styledBackgroundButtonWithOrigin:CGPointMake(160, 500) text:@"Log In"];
    [self.logInButton addTarget:self action:@selector(logInUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logInButton];
    
    self.registerButton = [button styledBackgroundButtonWithOrigin:CGPointMake(160, 600) text:@"Register Here"];
    [self.registerButton addTarget:self action:@selector(segueToRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
}

- (void) createLabel {
    [[self logInLabel] setFont: [UIFont systemFontOfSize:24]];
    self.logInLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)logInUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            // Create alert
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incorrect Username or Password"
                                                                           message:@"Please reenter username or password."
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            // Create a dismiss action
            UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      // Handle cancel response here. Doing nothing will dismiss the view.
                                                                  }];
            // Add the cancel action to the alertController
            [alert addAction:dismissAction];
            alert.view.tintColor = [UIColor colorWithRed:134.0/255.0f green:43.0/255.0f blue:142.0/255.0f alpha:1.0f];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            // Display view controller that needs to be shown after successful login
            [self performSegueWithIdentifier:@"toMain" sender:self];
        }
    }];
}

- (void)segueToRegister {
    [self performSegueWithIdentifier:@"toRegister" sender:self];
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
