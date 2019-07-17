//
//  LocationViewController.m
//  fbu-app
//
//  Created by lucjia on 7/17/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "LocationViewController.h"
#import "Parse/Parse.h"

@interface LocationViewController ()

@property (strong, nonatomic) PFGeoPoint *userLocation;
@property (strong, nonatomic) NSDictionary *locationDictionary;
@property (strong, nonatomic) NSDictionary *addressDictionary;
@property (strong, nonatomic) UITextField *addressField;
@property (strong, nonatomic) UIButton *addressButton;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create address field
    self.addressField = [[UITextField alloc] initWithFrame: CGRectMake(80.0f, 240.0f, 215.0f, 30.0f)];
    self.addressField.delegate = self;
    self.addressField.borderStyle = UITextBorderStyleRoundedRect;
    self.addressField.placeholder = @"Enter Your Address";
    [self.view addSubview:self.addressField];
    
    // Create Address button
    self.addressButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.addressButton.frame = CGRectMake(137.5f, 50, 100.0f, 30.0f);
    self.addressButton.backgroundColor = [UIColor lightGrayColor];
    self.addressButton.tintColor = [UIColor whiteColor];
    self.addressButton.layer.cornerRadius = 6;
    self.addressButton.clipsToBounds = YES;
    [self.addressButton addTarget:self action:@selector(fetchCoordinates) forControlEvents:UIControlEventTouchUpInside];
    [self.addressButton setTitle:@"Find Location" forState:UIControlStateNormal];
    [self.view addSubview:self.addressButton];
}

- (void)fetchCoordinates {
    NSString *addressFieldContent = [self.addressField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *urlstring = [[NSArray arrayWithObjects:@"https://maps.googleapis.com/maps/api/geocode/json?address=", addressFieldContent, @"&key=AIzaSyBii9SGFD6Hih4gd4PINM_tUKLjmETAmUU", nil] componentsJoinedByString:@""];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.locationDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.addressDictionary = self.locationDictionary[@"results"];
            NSLog(@"%@", self.addressDictionary[@"geometry"]);
    }];
        
    // THINGS TO DO:
    // create separate method to process the api request (see flix)
    // store information from request to a dictionary, and then store that as an array of "results" (see flix)
    // use the information provided by lat and lng on the api to create user location as a geopoint
    // set current user's location to be the geopoint
    
    //    self.userLocation = [PFGeoPoint geoPointWithLatitude:40.0 longitude:-30.0];
    //    [[PFUser currentUser] setObject:self.userLocation forKey:@"location"];
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
