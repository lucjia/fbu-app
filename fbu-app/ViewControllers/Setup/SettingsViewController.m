//
//  SettingsViewController.m
//  fbu-app
//
//  Created by lucjia on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "SettingsViewController.h"
#import "LocationViewController.h"
#import "PreferencesViewController.h"
#import "LogInViewController.h"
#import "Parse/Parse.h"

@interface SettingsViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *changeProfileButton;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (weak, nonatomic) IBOutlet UITextField *fullNameField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UIButton *userPreferencesButton;
@property (weak, nonatomic) IBOutlet UIButton *userLocationButton;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UIButton *changeBioButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [PFUser currentUser];
    [self createProfileImageView];
    [self createChangeProfileButton];
    [self createFullNameField];
    [self createCityField];
    [self createUserPreferencesButton];
    [self createUserLocationButton];
    [self createUserBioTextView];
    [self createChangeBioButton];
    [self createContinueButton];
    [self createLogOutButton];
}

- (void) createProfileImageView {
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    self.profileImageView.clipsToBounds = YES;
    [self getProfilePicture];
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.profileImageView setBackgroundColor:[UIColor redColor]];
}

- (void) createChangeProfileButton {
    self.changeProfileButton.backgroundColor = [UIColor lightGrayColor];
    self.changeProfileButton.tintColor = [UIColor whiteColor];
    self.changeProfileButton.layer.cornerRadius = 6;
    self.changeProfileButton.clipsToBounds = YES;
    [self.changeProfileButton addTarget:self action:@selector(pressedChangePic) forControlEvents:UIControlEventTouchUpInside];
}

- (void) createFullNameField {
    self.fullNameField.delegate = self;
    self.fullNameField.borderStyle = UITextBorderStyleRoundedRect;
    self.fullNameField.placeholder = @"Full Name";
    NSString *firstName = [[PFUser currentUser][@"firstName"] stringByAppendingString:@" "];
    NSString *fullName = [firstName stringByAppendingString:[PFUser currentUser][@"lastName"]];
    self.fullNameField.text = fullName;
}

- (void) createCityField {
    self.cityField.delegate = self;
    self.cityField.borderStyle = UITextBorderStyleRoundedRect;
    self.cityField.placeholder = @"City, State (ex: San Francisco, CA)";
    NSString *existingCity = [[PFUser currentUser][@"city"] stringByAppendingString:@", "];
    NSString *existingState = [existingCity stringByAppendingString:[PFUser currentUser][@"state"]];
    self.cityField.text = existingState;
}

- (void) createUserPreferencesButton {
    self.userPreferencesButton.backgroundColor = [UIColor lightGrayColor];
    self.userPreferencesButton.tintColor = [UIColor whiteColor];
    self.userPreferencesButton.layer.cornerRadius = 6;
    self.userPreferencesButton.clipsToBounds = YES;
    [self.userPreferencesButton addTarget:self action:@selector(setPreferences) forControlEvents:UIControlEventTouchUpInside];
}

- (void) createUserLocationButton {
    self.userLocationButton.backgroundColor = [UIColor lightGrayColor];
    self.userLocationButton.tintColor = [UIColor whiteColor];
    self.userLocationButton.layer.cornerRadius = 6;
    self.userLocationButton.clipsToBounds = YES;
    [self.userLocationButton addTarget:self action:@selector(setLocation) forControlEvents:UIControlEventTouchUpInside];
}

- (void) createUserBioTextView {
    self.bioTextView.text = [PFUser currentUser][@"bio"];
    if ([self.bioTextView.text isEqualToString:@""]) {
        self.bioTextView.text = @"Write a bio...";
        self.bioTextView.textColor = [UIColor lightGrayColor];
    }
    self.bioTextView.layer.borderWidth = 1.5f;
    self.bioTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.bioTextView.layer.cornerRadius = 6;
    self.bioTextView.delegate = self;
}

- (void) createChangeBioButton {
    self.changeBioButton.backgroundColor = [UIColor lightGrayColor];
    self.changeBioButton.tintColor = [UIColor whiteColor];
    self.changeBioButton.layer.cornerRadius = 6;
    self.changeBioButton.clipsToBounds = YES;
    [self.changeBioButton addTarget:self action:@selector(setBio) forControlEvents:UIControlEventTouchUpInside];
}

- (void) createContinueButton {
    self.continueButton.backgroundColor = [UIColor lightGrayColor];
    self.continueButton.tintColor = [UIColor whiteColor];
    self.continueButton.layer.cornerRadius = 6;
    self.continueButton.clipsToBounds = YES;
    [self.continueButton addTarget:self action:@selector(goToTimeline) forControlEvents:UIControlEventTouchUpInside];
}

-(void) createLogOutButton {
    self.logOutButton.backgroundColor = [UIColor lightGrayColor];
    self.logOutButton.tintColor = [UIColor whiteColor];
    self.logOutButton.layer.cornerRadius = 6;
    self.logOutButton.clipsToBounds = YES;
    [self.logOutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
}

// Dismiss keyboard after typing
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

// Change User Profile Picture
-(void) pressedChangePic {
    [self createUIImagePickerController];
    [self openCameraOrRoll];
}

- (void)createUIImagePickerController {
    // Instantiate UIImagePickerController
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    
    // Set UIImagePickerController based on availability of camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        // Use photo library
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

- (void)openCameraOrRoll {
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

// Return dictionary of image and other information
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    // Do something with the images (based on your use case)
    self.resizedImage = [self resizeImage:originalImage withSize:CGSizeMake(400, 400)];
    NSLog(@"Resized image");
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^{
        [self setProfilePicture];
    }];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)setProfilePicture {
    NSData *imageData = UIImagePNGRepresentation(self.resizedImage);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    
    [[PFUser currentUser] setObject:imageFile forKey:@"profileImage"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            self.profileImageView.image = self.resizedImage;
            [self getProfilePicture];
        }
    }];
}

-(void)getProfilePicture {
    [[PFUser currentUser][@"profilePicture"] getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error && imageData) {
            //If there was no error with the internet request and some kind of data was returned, use that data to form the profile image with the handy method of UIImage.
            
            //Set the image view to the image with the data returned from Parse.
            self.profileImageView.image = [UIImage imageWithData:imageData];
        } else {
            // Create alert
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Photo Not Changed"
                                                                           message:@"Your photo has not been changed."
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
        }
    }];
}

// Change User Bio / About Me
- (void)setBio {
    [[PFUser currentUser] setObject:self.bioTextView.text forKey:@"bio"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Create alert
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Bio Changed"
                                                                           message:@"Your bio has been changed."
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
        }
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.bioTextView.text isEqualToString:@"Write a bio..."]) {
        self.bioTextView.text = @"";
        self.bioTextView.textColor = [UIColor blackColor];
    }
    [self.bioTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.bioTextView.text isEqualToString:@""]) {
        self.bioTextView.text = @"Write a bio...";
        self.bioTextView.textColor = [UIColor lightGrayColor];
    }
    [self.bioTextView resignFirstResponder];
}

// Set User Location
- (void)setLocation {
    [self setFieldInformation];
    [self performSegueWithIdentifier:@"toLocation" sender:self];
}

- (void)setPreferences {
    [self performSegueWithIdentifier:@"toPreferences" sender:self];
}

- (void)goToTimeline {
    [self setFieldInformation];
    
    [self performSegueWithIdentifier:@"toTimeline" sender:self];
}

- (void)setFieldInformation {
    // set Full name and City
    // Make this robust by creating restrictions if the text field is empty, only one name, etc.
    if (![self.fullNameField.text isEqualToString:@""]) {
        NSArray *nameSections = [self.fullNameField.text componentsSeparatedByString:@" "];
        NSString *firstName = [nameSections objectAtIndex:0];
        NSString *lastName = [nameSections objectAtIndex:1];
        [[PFUser currentUser] setObject:firstName forKey:@"firstName"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        }];
        
        [[PFUser currentUser] setObject:lastName forKey:@"lastName"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        }];
    }
    
    if (![self.cityField.text isEqualToString:@""]) {
        NSArray *citySections = [self.cityField.text componentsSeparatedByString:@", "];
        NSString *city = [citySections objectAtIndex:0];
        NSString *state = [citySections objectAtIndex:1];
        [[PFUser currentUser] setObject:city forKey:@"city"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        }];
        
        [[PFUser currentUser] setObject:state forKey:@"state"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        }];
    }
}

- (void) logOut {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    // Set root view controller to be log in screen
    LogInViewController *logInVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogInViewController"];
    [self presentViewController:logInVC animated:YES completion:nil];
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