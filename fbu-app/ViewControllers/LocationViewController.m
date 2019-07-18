//
//  LocationViewController.m
//  fbu-app
//
//  Created by lucjia on 7/17/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "LocationViewController.h"
#import "Parse/Parse.h"
@import NMAKit;

@interface LocationViewController ()

@property (strong, nonatomic) PFGeoPoint *userLocation;
@property (strong, nonatomic) NSArray *locationArray;
@property (strong, nonatomic) NSArray *addressArray;
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
//    NSString *addressFieldContent = [self.addressField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    NSString *urlstring = [[NSArray arrayWithObjects:@"https://geocoder.api.here.com/6.2/geocode.json?app_id={z4NMKPCmnbuXpbM1cBF4}&app_code={Ov375inKDjm_wAAfZRSAsA}", addressFieldContent, nil] componentsJoinedByString:@""];
//    NSLog(@"%@", urlstring);
    
    // 37.4848, -122.1484
    
    NSString *locationSearch = self.addressField.text;
    NMAGeoCoordinates *fbCoordinate = [NMAGeoCoordinates geoCoordinatesWithLatitude:37.4848 longitude:-122.1484];
    NMAGeocodeRequest *request = [[NMAGeocoder sharedGeocoder] createGeocodeRequestWithQuery:locationSearch searchRadius:5000 searchCenter:fbCoordinate];
    [request startWithBlock:^(NMARequest* request, id data, NSError* error) {
        NSString *resultString = @"";
        
        NSMutableArray* results = (NSMutableArray*)data;
        // From the array of NMAGeocodeResult object,we retrieve the coordinate information and
        // display to the screen.Please refer to HERE Android SDK doc for other supported APIs.
        for (NMAGeocodeResult* result in results) {
            NMAGeoCoordinates* position = result.location.position;
            resultString = [resultString
                            stringByAppendingString:[NSString stringWithFormat:@"%f,%f\n", position.latitude,
                                                     position.longitude]];
            NSLog(@"%@", resultString);
        }
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
