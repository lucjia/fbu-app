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

@interface ComposePostViewController () <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    NSArray *trackedLocations;
    PFGeoPoint *currLocation;
}

@property (weak, nonatomic) IBOutlet UIButton *shareLocationButton;
@property (weak, nonatomic) IBOutlet UITextView *postTextView;

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
}

- (IBAction)didTap:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressPost:(id)sender {
    if (trackedLocations != nil) {
        currLocation = [[PFGeoPoint alloc] init];
        CLLocation *loc = [trackedLocations lastObject];
        currLocation.latitude = loc.coordinate.latitude;
        currLocation.longitude = loc.coordinate.longitude;
    }
        
    if ([self.postTextView.text isEqualToString:@""] && currLocation == nil) {
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
        alert.view.tintColor = [UIColor redColor];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (currLocation == nil) {
        [Post createPostWithSender:[PFUser currentUser][@"persona"] text:self.postTextView.text withCompletion:nil];
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    } else {
        [Post createPostWithSender:[PFUser currentUser][@"persona"] text:[self.postTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@", currLocation]] location:currLocation withCompletion:nil];
        // stop tracking location
        [locationManager stopUpdatingLocation];
    }
}

- (IBAction)didPressLocation:(id)sender {
    // access user's current location and create post based on that
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    trackedLocations = locations;
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
