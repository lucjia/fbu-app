//
//  ComposePostViewController.m
//  fbu-app
//
//  Created by lucjia on 8/5/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "ComposePostViewController.h"
#import "Parse/Parse.h"
#import "Post.h"
#import <CoreLocation/CoreLocation.h>
#import "QuartzCore/QuartzCore.h"
#import "BulletinViewController.h"
#import "CustomColor.h"
#import "Accessibility.h"

// Foursquare API
static NSString * const clientID = @"EQAQQVVKNHWZQCKEJA1HUSNOOLCVXZEI3UD5A2XH34VNLPA4";
static NSString * const clientSecret = @"3VJ2WHVGZ4GHBVFBYOXVN2FGNILHHDU4YJBISVQ1X1S0RLYV";

@interface ComposePostViewController () <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    NSArray *trackedLocations;
    PFGeoPoint *currLocation;
    NSString *currLocationString;
}

@property (weak, nonatomic) IBOutlet UIButton *shareLocationButton;
@property (weak, nonatomic) IBOutlet UITextView *postTextView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *locationButtonView;
@property (weak, nonatomic) IBOutlet UIView *postButtonView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set up location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [self roundCornersWithView:self.backgroundView radius:10];
    [self roundCornersWithView:self.locationButtonView radius:5];
    [self roundCornersWithView:self.postButtonView radius:5];
    
    [self initializeTextView];
    
    [self initializeLargeTextCompatibility];
    
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

- (void) initializeLargeTextCompatibility {
    [Accessibility largeTextCompatibilityWithLabel:self.shareLocationButton.titleLabel style:UIFontTextStyleBody];
    [Accessibility largeTextCompatibilityWithView:self.postTextView style:UIFontTextStyleBody];
    [Accessibility largeTextCompatibilityWithLabel:self.postButton.titleLabel style:UIFontTextStyleBody];
    [Accessibility largeTextCompatibilityWithLabel:self.backButton.titleLabel style:UIFontTextStyleSubheadline];
}

- (void) roundCornersWithView:(UIView *)view radius:(double)radius {
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

- (IBAction)didTap:(id)sender {
    [self.postTextView resignFirstResponder];
}

- (IBAction)didPressBack:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressPost:(id)sender {
    if (trackedLocations != nil) {
        currLocation = [[PFGeoPoint alloc] init];
        CLLocation *loc = [trackedLocations lastObject];
        currLocation.latitude = loc.coordinate.latitude;
        currLocation.longitude = loc.coordinate.longitude;
        [self reverseGeocode];
    } else {
        [self postToParse];
    }
}

- (IBAction)didPressLocation:(id)sender {
    // access user's current location and create post based on that
    [locationManager startUpdatingLocation];
    self.shareLocationButton.titleLabel.text = @"Sharing Location";
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
            currLocationString = [[[responseDictionary valueForKeyPath:@"response.venues"] objectAtIndex:0] valueForKey:@"name"];
            [self postToParse];
        }
    }];
    [task resume];
}

- (void) postToParse {
    if (([self.postTextView.text isEqualToString:@""] || [self.postTextView.text isEqualToString:@"Write a note..."]) && currLocation == nil) {
        // Create alert to display error
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Post"
                                                                       message:@"Please enter a memo or share a location."
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
    } else if (currLocation == nil) {
        [Post createPostWithSender:[PFUser currentUser][@"persona"] text:self.postTextView.text withCompletion:nil];
        [self.delegate refresh];
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSString *postText;
        if ([self.postTextView.text isEqualToString:@""]) {
            postText = [NSString stringWithFormat:@"I am at this location: %@", currLocationString];
        } else {
            postText = [self.postTextView.text stringByAppendingString:[NSString stringWithFormat:@"\r\rI am at this location: %@", currLocationString]];
        }
        [Post createPostWithSender:[PFUser currentUser][@"persona"] text:postText location:currLocation venue:currLocationString withCompletion:nil];
        // stop tracking location
        [locationManager stopUpdatingLocation];
        [self.delegate refresh];
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) initializeTextView {
    self.postTextView.delegate = self;
    if ([self.postTextView.text isEqualToString:@""]) {
        self.postTextView.text = @"Write a note...";
        self.postTextView.textColor = [UIColor lightGrayColor];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.postTextView.text isEqualToString:@"Write a note..."]) {
        self.postTextView.text = @"";
        self.postTextView.textColor = [CustomColor darkMainColor:1.0];
    }
    [self.postTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.postTextView.text isEqualToString:@""]) {
        self.postTextView.text = @"Write a note...";
        self.postTextView.textColor = [UIColor lightGrayColor];
    }
    [self.postTextView resignFirstResponder];
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
