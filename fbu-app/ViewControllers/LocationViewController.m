//
//  LocationViewController.m
//  fbu-app
//
//  Created by lucjia on 7/17/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "LocationViewController.h"
#import "UIImageView+AFNetworking.h"
#import "LocationCell.h"
#import "Parse/Parse.h"

static NSString * const clientID = @"EQAQQVVKNHWZQCKEJA1HUSNOOLCVXZEI3UD5A2XH34VNLPA4";
static NSString * const clientSecret = @"3VJ2WHVGZ4GHBVFBYOXVN2FGNILHHDU4YJBISVQ1X1S0RLYV";

@interface LocationViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) PFGeoPoint *userLocation;
@property (strong, nonatomic) NSArray *locationArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *results;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
}

//- (void)fetchCoordinates {
//    NSString *addressFieldContent = [self.addressField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    NSString *urlstring = [[NSArray arrayWithObjects:@"https://geocoder.api.here.com/6.2/geocode.json?app_id={z4NMKPCmnbuXpbM1cBF4}&app_code={Ov375inKDjm_wAAfZRSAsA}", addressFieldContent, nil] componentsJoinedByString:@""];
//    NSLog(@"%@", urlstring);
    
    // 37.4848, -122.1484
    
//    NSString *locationSearch = self.addressField.text;
//    NMAGeoCoordinates *fbCoordinate = [NMAGeoCoordinates geoCoordinatesWithLatitude:37.4848 longitude:-122.1484];
//    NMAGeocodeRequest *request = [[NMAGeocoder sharedGeocoder] createGeocodeRequestWithQuery:locationSearch searchRadius:5000 searchCenter:fbCoordinate];
//    [request startWithBlock:^(NMARequest* request, id data, NSError* error) {
//        NSString *resultString = @"";
//
//        NSMutableArray* results = (NSMutableArray*)data;
//        // From the array of NMAGeocodeResult object,we retrieve the coordinate information and
//        // display to the screen.Please refer to HERE Android SDK doc for other supported APIs.
//        for (NMAGeocodeResult* result in results) {
//            NMAGeoCoordinates* position = result.location.position;
//            resultString = [resultString
//                            stringByAppendingString:[NSString stringWithFormat:@"%f,%f\n", position.latitude,
//                                                     position.longitude]];
//            NSLog(@"%@", resultString);
//        }
//    }];
    
//    NSString *addressFieldContent = [self.addressField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    NSString *urlstring = [[NSArray arrayWithObjects:@"https://maps.googleapis.com/maps/api/geocode/json?address=", addressFieldContent, @"&key=AIzaSyBii9SGFD6Hih4gd4PINM_tUKLjmETAmUU", nil] componentsJoinedByString:@""];
//    NSURL *url = [NSURL URLWithString:urlstring];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        self.locationDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        self.addressDictionary = self.locationDictionary[@"results"];
//            NSLog(@"%@", self.addressDictionary[@"geometry"]);
//    }];

    // THINGS TO DO:
    // create separate method to process the api request (see flix)
    // store information from request to a dictionary, and then store that as an array of "results" (see flix)
    // use the information provided by lat and lng on the api to create user location as a geopoint
    // set current user's location to be the geopoint
    
    //    self.userLocation = [PFGeoPoint geoPointWithLatitude:40.0 longitude:-30.0];
    //    [[PFUser currentUser] setObject:self.userLocation forKey:@"location"];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is the selected venue
    NSDictionary *venue = self.results[indexPath.row];
    NSNumber *lat = [venue valueForKeyPath:@"location.lat"];
    NSNumber *lng = [venue valueForKeyPath:@"location.lng"];
    [self.delegate locationViewController:self didPickLocationWithLatitude:lat longitude:lng];
    NSLog(@"%@, %@", lat, lng);
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self fetchLocationsWithQuery:newText nearCity:@"San Francisco"];
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchLocationsWithQuery:searchBar.text nearCity:@"San Francisco"];
}

- (void)fetchLocationsWithQuery:(NSString *)query nearCity:(NSString *)city {
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/search?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&near=%@,CA&query=%@", clientID, clientSecret, city, query];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"response: %@", responseDictionary);
            self.results = [responseDictionary valueForKeyPath:@"response.venues"];
            [self.tableView reloadData];
        }
    }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

// Determines which cell is at each row (returns an instance of the custom cell
// with reuse identifier with the data that the index asked for
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];

    [cell updateWithLocation:self.results[indexPath.row]];
    return cell;
    
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
