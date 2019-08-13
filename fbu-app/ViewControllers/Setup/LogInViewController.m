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
#import "CustomColor.h"
#import "Persona.h"
#import "House.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "MainViewController.h"

@interface LogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *logInLabel;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logInButton.layer.cornerRadius = 5;
    self.logInButton.layer.masksToBounds = YES;
    
    self.registerButton.layer.cornerRadius = 5;
    self.registerButton.layer.masksToBounds = YES;
}

- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
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
            alert.view.tintColor = [CustomColor accentColor:1.0];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
            [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                House *house = [persona objectForKey:@"house"];
                if (house) {
                    // if the user is already in a house, display post-search
                    UIStoryboard *postSearch = [UIStoryboard storyboardWithName:@"PostSearch" bundle:nil];
                    LGSideMenuController *sideMenuController = [postSearch instantiateViewControllerWithIdentifier:@"PostSearchSideMenuController"];
                    
                    UITabBarController *rootView = (UITabBarController *)sideMenuController.rootViewController;
                    
                    [rootView setSelectedIndex:0];
                    [self presentViewController:sideMenuController animated:YES completion:nil];
                } else {
                    // display timeline
                    // Display view controller that needs to be shown after successful login
                    [self performSegueWithIdentifier:@"toMain" sender:self];
                }
            }];
        }
    }];
}

- (IBAction)didPressLogIn:(id)sender {
    [self logInUser];
}

- (IBAction)didPressRegister:(id)sender {
    [self segueToRegister];
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
