//
//  SettingsViewController.m
//  fbu-app
//
//  Created by lucjia on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "SettingsViewController.h"
#import "LocationViewController.h"
#import "Parse/Parse.h"

@interface SettingsViewController () <UITextViewDelegate>

@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UIButton *changeProfileButton;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (strong, nonatomic) UIButton *userPreferencesButton;
@property (strong, nonatomic) UIButton *userLocationButton;
@property (strong, nonatomic) UITextView *bioTextView;
@property (strong, nonatomic) UIButton *changeBioButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [PFUser currentUser];
    
    // Create Profile image view
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(127.5f, 100, 120, 120)];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    self.profileImageView.clipsToBounds = YES;
    [self getProfilePicture];
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
    [self.changeProfileButton addTarget:self action:@selector(pressedChangePic) forControlEvents:UIControlEventTouchUpInside];
    [self.changeProfileButton setTitle:@"Change Profile Picture" forState:UIControlStateNormal];
    [self.view addSubview:self.changeProfileButton];
    
    // Create User Preferences button
    self.userPreferencesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.userPreferencesButton.frame = CGRectMake(137.5f, 300, 100.0f, 30.0f);
    self.userPreferencesButton.backgroundColor = [UIColor lightGrayColor];
    self.userPreferencesButton.tintColor = [UIColor whiteColor];
    self.userPreferencesButton.layer.cornerRadius = 6;
    self.userPreferencesButton.clipsToBounds = YES;
    [self.userPreferencesButton addTarget:self action:@selector(setUserPreferences) forControlEvents:UIControlEventTouchUpInside];
    [self.userPreferencesButton setTitle:@"Change User Preferences" forState:UIControlStateNormal];
    [self.view addSubview:self.userPreferencesButton];
    
    // Create User Location
    self.userLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.userLocationButton.frame = CGRectMake(137.5f, 600, 100.0f, 30.0f);
    self.userLocationButton.backgroundColor = [UIColor lightGrayColor];
    self.userLocationButton.tintColor = [UIColor whiteColor];
    self.userLocationButton.layer.cornerRadius = 6;
    self.userLocationButton.clipsToBounds = YES;
    [self.userLocationButton addTarget:self action:@selector(setLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.userLocationButton setTitle:@"Change Location" forState:UIControlStateNormal];
    [self.view addSubview:self.userLocationButton];
    
    // Create User Bio text view
    self.bioTextView = [[UITextView alloc] initWithFrame:CGRectMake(125, 360, 200, 200)];
    self.bioTextView.text = [PFUser currentUser][@"bio"];
    if ([self.bioTextView.text isEqualToString:@""]) {
        self.bioTextView.text = @"Write a bio...";
        self.bioTextView.textColor = [UIColor lightGrayColor];
    }
    self.bioTextView.layer.borderWidth = 1.5f;
    self.bioTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.bioTextView.layer.cornerRadius = 6;
    self.bioTextView.delegate = self;
    [self.view addSubview:self.bioTextView];
    
    // Create Change Bio button
    self.changeBioButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.changeBioButton.frame = CGRectMake(137.5f, 50, 100.0f, 30.0f);
    self.changeBioButton.backgroundColor = [UIColor lightGrayColor];
    self.changeBioButton.tintColor = [UIColor whiteColor];
    self.changeBioButton.layer.cornerRadius = 6;
    self.changeBioButton.clipsToBounds = YES;
    [self.changeBioButton addTarget:self action:@selector(setBio) forControlEvents:UIControlEventTouchUpInside];
    [self.changeBioButton setTitle:@"Change Bio" forState:UIControlStateNormal];
    [self.view addSubview:self.changeBioButton];
}

// Dismiss keyboard after typing
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)setUserPreferences {
    // add code regarding segue to user preferences
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
    LocationViewController *locationVC = [[LocationViewController alloc] init];
    // Any setup
    [self presentModalViewController:locationVC animated:YES];
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
