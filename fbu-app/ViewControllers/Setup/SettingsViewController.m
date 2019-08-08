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
#import "CustomColor.h"
#import "Accessibility.h"

// Foursquare API
static NSString * const clientID = @"EQAQQVVKNHWZQCKEJA1HUSNOOLCVXZEI3UD5A2XH34VNLPA4";
static NSString * const clientSecret = @"3VJ2WHVGZ4GHBVFBYOXVN2FGNILHHDU4YJBISVQ1X1S0RLYV";

@interface SettingsViewController () <UITextViewDelegate, LocationViewControllerDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    NSArray *trackedLocations;
    PFGeoPoint *currLocation;
    NSString *currLocationString;
}

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *changeProfileButton;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (weak, nonatomic) IBOutlet UITextField *fullNameField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *userPreferencesButton;
@property (weak, nonatomic) IBOutlet UIButton *userLocationButton;
@property (weak, nonatomic) IBOutlet UITextField *radiusField;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *milesLabel;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;

// For saving in Persona via persona method
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) PFGeoPoint *location;
@property (strong, nonatomic) NSNumber *radius;

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
    [self createRadiusField];
    [self createUserPreferencesButton];
    [self createUserLocationButtonLabel];
    [self createUserBioTextView];
    
    // set up location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    // get notification if font size is changed from settings accessibility
    [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(preferredContentSizeChanged:)
         name:UIContentSizeCategoryDidChangeNotification
         object:nil];
}

// change font size based on accessibility setting
- (void)preferredContentSizeChanged:(NSNotification *)notification {
}

- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
}

- (void) setLocationLabelWithLocation:(NSString *)location {
    self.currentLocationLabel.text = [@"Location: " stringByAppendingString:location];
    self.currentLocationLabel.adjustsFontForContentSizeCategory = YES;
}

- (void) createProfileImageView {
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    self.profileImageView.clipsToBounds = YES;
    [[[PFUser currentUser][@"persona"] objectForKey:@"profileImage"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        NSData *imageData = data;
        self.profileImageView.image = [[UIImage alloc] initWithData:imageData];
    }];
    if (self.profileImageView.image == nil) {
        self.profileImageView.image = [UIImage imageNamed:@"profileImage"];
    }
    self.profileImage = self.profileImageView.image;
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.profileImageView.layer.borderWidth = 4;
    self.profileImageView.layer.borderColor = [CustomColor darkMainColor:1.0].CGColor;
}

- (void) createChangeProfileButton {
    [self.changeProfileButton addTarget:self action:@selector(pressedChangePic) forControlEvents:UIControlEventTouchUpInside];
    
    [Accessibility largeTextCompatibilityWithLabel:self.changeProfileButton.titleLabel style:UIFontTextStyleHeadline];
}

- (void) createFullNameField {
    self.fullNameField.delegate = self;
    self.fullNameField.borderStyle = UITextBorderStyleRoundedRect;
    self.fullNameField.placeholder = @"Full Name";
    NSString *firstName = [[PFUser currentUser][@"persona"][@"firstName"] stringByAppendingString:@" "];
    NSString *fullName = [firstName stringByAppendingString:[PFUser currentUser][@"persona"][@"lastName"]];
    self.fullNameField.text = fullName;
    
    [Accessibility largeTextCompatibilityWithField:self.fullNameField style:UIFontTextStyleBody];
}

- (void) createCityField {
    self.cityField.delegate = self;
    self.cityField.borderStyle = UITextBorderStyleRoundedRect;
    self.cityField.placeholder = @"City, State (ex: Seattle, WA)";
    NSString *existingCity = [[PFUser currentUser][@"persona"][@"city"] stringByAppendingString:@", "];
    NSString *existingState = [existingCity stringByAppendingString:[PFUser currentUser][@"persona"][@"state"]];
    self.cityField.text = existingState;
    
    [Accessibility largeTextCompatibilityWithField:self.cityField style:UIFontTextStyleBody];
}

- (void) createRadiusField {
    self.radiusField.delegate = self;
    self.radiusField.borderStyle = UITextBorderStyleRoundedRect;
    self.radiusField.placeholder = @"Radius";
    NSNumber *radius = [PFUser currentUser][@"persona"][@"radius"];
    if (radius > 0) {
        self.radiusField.text = [NSString stringWithFormat:@"%@", radius];
    }
    
    [Accessibility largeTextCompatibilityWithField:self.radiusField style:UIFontTextStyleBody];
}

- (void) createUserPreferencesButton {
    self.userPreferencesButton.layer.cornerRadius = 6;
    self.userPreferencesButton.clipsToBounds = YES;
    
    [Accessibility largeTextCompatibilityWithLabel:self.userPreferencesButton.titleLabel style:UIFontTextStyleBody];
}

- (void) createUserLocationButtonLabel {
    if ([[PFUser currentUser][@"persona"] objectForKey:@"venue"] == nil) {
        self.currentLocationLabel.text = @"Location: Not set yet!";
    } else {
        self.currentLocationLabel.text = [@"Location: " stringByAppendingString:[[PFUser currentUser][@"persona"] objectForKey:@"venue"]];
    }
    
    [Accessibility largeTextCompatibilityWithLabel:self.userLocationButton.titleLabel style:UIFontTextStyleHeadline];
    [Accessibility largeTextCompatibilityWithLabel:self.currentLocationLabel style:UIFontTextStyleBody];
    [Accessibility largeTextCompatibilityWithLabel:self.milesLabel style:UIFontTextStyleBody];
    [Accessibility largeTextCompatibilityWithLabel:self.currentLocationButton.titleLabel style:UIFontTextStyleHeadline];
}

- (void) createUserBioTextView {
    self.bioTextView.text = [PFUser currentUser][@"persona"][@"bio"];
    if ([self.bioTextView.text isEqualToString:@""]) {
        self.bioTextView.text = @"Write a bio...";
        self.bioTextView.textColor = [CustomColor midToneOne:1.0];
    }
    self.bioTextView.layer.borderWidth = 0.5f;
    self.bioTextView.layer.borderColor = [[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor];
    self.bioTextView.layer.cornerRadius = 5;
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
    
    [Accessibility largeTextCompatibilityWithView:self.bioTextView style:UIFontTextStyleBody];
    [Accessibility largeTextCompatibilityWithLabel:self.continueButton.titleLabel style:UIFontTextStyleHeadline];
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
            alert.view.tintColor = [CustomColor accentColor:1.0];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

// Change User Bio / About Me
- (void)setBio {
    [[PFUser currentUser][@"persona"] setObject:self.bioTextView.text forKey:@"bio"];
    [[PFUser currentUser][@"persona"] saveInBackground];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.bioTextView.text isEqualToString:@"Write a bio..."]) {
        self.bioTextView.text = @"";
        self.bioTextView.textColor = [CustomColor darkMainColor:1.0];
    }
    [self.bioTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.bioTextView.text isEqualToString:@""]) {
        self.bioTextView.text = @"Write a bio...";
        self.bioTextView.textColor = [CustomColor midToneOne:1.0];
    }
    [self.bioTextView resignFirstResponder];
}

- (IBAction)didPressSetPreferences:(id)sender {
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
    [Persona createPersona:self.firstName lastName:self.lastName bio:self.bio profileImage:self.profileImage city:self.city state:self.state location:self.location radius:self.radius withCompletion:nil];
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
        alert.view.tintColor = [CustomColor accentColor:1.0];
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
        alert.view.tintColor = [CustomColor accentColor:1.0];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if (![self.radiusField.text isEqualToString:@""] && [[self.cityField.text componentsSeparatedByString:@", "] count] == 2) {
        self.radius = @([self.radiusField.text intValue]);
        [[PFUser currentUser][@"persona"] setObject:self.radius forKey:@"radius"];
        [[PFUser currentUser][@"persona"] saveInBackground];
    } else {
        // Create alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Radius"
                                                                       message:@"Please enter an integer."
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
    }
    
    // Set bio
    if ([self.bioTextView.text isEqualToString:@"Write a bio..."] && self.bioTextView.textColor == [CustomColor midToneOne:1.0]) {
        self.bio = @"";
    } else {
        self.bio = self.bioTextView.text;
    }
    [self setBio];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self setFieldInformation];
    LocationViewController *locationViewController = (LocationViewController *)[segue destinationViewController];
    locationViewController.delegate = self;
    
    PreferencesViewController *prefVC = (PreferencesViewController *)[segue destinationViewController];
    prefVC.delegate = self;
}

- (IBAction)didPressUseCurrLocation:(id)sender {
    [locationManager startUpdatingLocation];
    
    [self performSelector:@selector(searchForLocation) withObject:nil afterDelay:1.0];
}

- (void) searchForLocation {
    if (trackedLocations != nil) {
        // stop tracking location
        [locationManager stopUpdatingLocation];
        
        currLocation = [[PFGeoPoint alloc] init];
        CLLocation *loc = [trackedLocations lastObject];
        currLocation.latitude = loc.coordinate.latitude;
        currLocation.longitude = loc.coordinate.longitude;
        [self reverseGeocode];
    } else {
        // Create alert to display error
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Find Location"
                                                                       message:@"Your current location cannot be found."
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
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    trackedLocations = locations;
}

- (void) reverseGeocode {
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/search?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&ll=%f,%f", clientID, clientSecret, currLocation.latitude, currLocation.longitude];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self->currLocationString = [[[responseDictionary valueForKeyPath:@"response.venues"] objectAtIndex:0] valueForKey:@"name"];
            self.city = [[[[responseDictionary valueForKeyPath:@"response.venues"] objectAtIndex:0] valueForKey:@"location"] valueForKey:@"city"];
            self.state = [[[[responseDictionary valueForKeyPath:@"response.venues"] objectAtIndex:0] valueForKey:@"location"] valueForKey:@"state"];
            self.currentLocationLabel.text = [@"Location: " stringByAppendingString:self->currLocationString];
            self.cityField.text = [[self.city stringByAppendingString:@", "] stringByAppendingString:self.state];
            // Set location in Parse
            [[PFUser currentUser][@"persona"] setObject:self->currLocation forKey:@"geoPoint"];
            [[PFUser currentUser][@"persona"] setObject:self->currLocationString forKey:@"venue"];
            [[PFUser currentUser][@"persona"] setObject:self.city forKey:@"city"];
            [[PFUser currentUser][@"persona"] setObject:self.state forKey:@"state"];
            
            [[PFUser currentUser][@"persona"] saveInBackground];
        }
    }];
    
    [task resume];
}

@end
