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
#import "Persona.h"
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
@property (weak, nonatomic) IBOutlet UIButton *featuresButton;

// For saving in Persona via persona method
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) PFGeoPoint *location;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [PFUser currentUser];
    if (self.user[@"persona"] == nil) {
        [Persona createPersonaUponRegistrationWithCompletion:nil];
    }
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

- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
}

- (void) createProfileImageView {
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    self.profileImageView.clipsToBounds = YES;
    [[[PFUser currentUser][@"persona"] objectForKey:@"profileImage"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        NSData *imageData = data;
        self.profileImageView.image = [[UIImage alloc] initWithData:imageData];
    }];
    if (self.profileImageView.image != nil) {
        self.profileImage = self.profileImageView.image;
    } else {
        self.profileImage = [UIImage imageNamed:@"profileImage"];
        self.profileImageView.image = [UIImage imageNamed:@"profileImage"];
    }
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
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
    NSString *firstName = [[PFUser currentUser][@"persona"][@"firstName"] stringByAppendingString:@" "];
    NSString *fullName = [firstName stringByAppendingString:[PFUser currentUser][@"persona"][@"lastName"]];
    self.fullNameField.text = fullName;
}

- (void) createCityField {
    self.cityField.delegate = self;
    self.cityField.borderStyle = UITextBorderStyleRoundedRect;
    self.cityField.placeholder = @"City, State (ex: Seattle, WA)";
    NSString *existingCity = [[PFUser currentUser][@"persona"][@"city"] stringByAppendingString:@", "];
    NSString *existingState = [existingCity stringByAppendingString:[PFUser currentUser][@"persona"][@"state"]];
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
    self.bioTextView.text = [PFUser currentUser][@"persona"][@"bio"];
    if ([self.bioTextView.text isEqualToString:@""]) {
        self.bioTextView.text = @"Write a bio...";
        self.bioTextView.textColor = [UIColor lightGrayColor];
    }
    self.bioTextView.layer.borderWidth = 1.5f;
    self.bioTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.bioTextView.layer.cornerRadius = 6;
    self.bioTextView.delegate = self;
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(yourTextViewDoneButtonPressed)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    self.bioTextView.inputAccessoryView = keyboardToolbar;
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

// Dismiss keyboard by pressing "done"
-(void)yourTextViewDoneButtonPressed {
    [self.bioTextView resignFirstResponder];
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
    
    [[PFUser currentUser][@"persona"] setObject:imageFile forKey:@"profileImage"];
    [[PFUser currentUser][@"persona"] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            self.profileImageView.image = self.resizedImage;
            self.profileImage = self.resizedImage;
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
    [[PFUser currentUser][@"persona"] setObject:self.bioTextView.text forKey:@"bio"];
    [[PFUser currentUser][@"persona"] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
    // set information in User
    [self setFieldInformation];
    // set user bio if changed
    if (![self.bioTextView.text isEqualToString:[PFUser currentUser][@"persona"][@"bio"]]) {
        [[PFUser currentUser][@"persona"] setObject:self.bioTextView.text forKey:@"bio"];
        [[PFUser currentUser][@"persona"] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        }];
    }
    self.location = [PFUser currentUser][@"persona"][@"geoPoint"];
    // set information in Persona
    [Persona createPersona:self.firstName lastName:self.lastName bio:self.bio profileImage:self.profileImage city:self.city state:self.state location:self.location withCompletion:nil];
    [self performSegueWithIdentifier:@"toTimeline" sender:self];
}

- (void)setFieldInformation {
    // set Full name and City
    // Robust: alert if the text field is empty, only one name, etc.
    if (![self.fullNameField.text isEqualToString:@""] && [[self.fullNameField.text componentsSeparatedByString:@" "] count] == 2) {
        NSArray *nameSections = [self.fullNameField.text componentsSeparatedByString:@" "];
        self.firstName = [nameSections objectAtIndex:0];
        self.lastName = [nameSections objectAtIndex:1];
        [[PFUser currentUser][@"persona"] setObject:self.firstName forKey:@"firstName"];
        [[PFUser currentUser][@"persona"] saveInBackground];
        
        [[PFUser currentUser][@"persona"] setObject:self.lastName forKey:@"lastName"];
        [[PFUser currentUser][@"persona"] saveInBackground];
    } else {
        // Create alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Name"
                                                                       message:@"Please enter your first and last name."
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
    
    if (![self.cityField.text isEqualToString:@""] && [[self.cityField.text componentsSeparatedByString:@", "] count] == 2) {
        NSArray *citySections = [self.cityField.text componentsSeparatedByString:@", "];
        self.city = [citySections objectAtIndex:0];
        self.state = [citySections objectAtIndex:1];
        [[PFUser currentUser][@"persona"] setObject:self.city forKey:@"city"];
        [[PFUser currentUser][@"persona"] saveInBackground];
        
        [[PFUser currentUser][@"persona"] setObject:self.state forKey:@"state"];
        [[PFUser currentUser][@"persona"] saveInBackground];
    } else {
        // Create alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid City"
                                                                       message:@"Please enter a city (ex: Seattle, WA)."
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
    
    // Set bio
    if ([self.bioTextView.text isEqualToString:@"Write a bio..."] && self.bioTextView.textColor == [UIColor lightGrayColor]) {
        self.bio = @"";
    } else {
        self.bio = self.bioTextView.text;
    }
}

- (void) logOut {
    [PFUser logOutInBackground];
    
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
