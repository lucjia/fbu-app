//
//  LocationViewController.m
//  fbu-app
//
//  Created by lucjia on 7/17/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "LocationViewController.h"
#import "LocationCell.h"
#import "Parse/Parse.h"

static NSString * const clientID = @"EQAQQVVKNHWZQCKEJA1HUSNOOLCVXZEI3UD5A2XH34VNLPA4";
static NSString * const clientSecret = @"3VJ2WHVGZ4GHBVFBYOXVN2FGNILHHDU4YJBISVQ1X1S0RLYV";

@interface LocationViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) PFGeoPoint *userLocation;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    [self setCity];
}

- (void) setCity {
    if (![[PFUser currentUser][@"city"] isEqualToString:@""] && ![[PFUser currentUser][@"state"] isEqualToString:@""]) {
        self.city = [PFUser currentUser][@"city"];
        self.state = [PFUser currentUser][@"state"];
        NSLog(@"%@", self.city);
        NSLog(@"%@", self.state);
    } else {
        self.city = @"San Francisco";
        self.state =@"CA";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is the selected venue
    NSDictionary *venue = self.results[indexPath.row];
    double lat = [[venue valueForKeyPath:@"location.lat"] doubleValue];
    double lng = [[venue valueForKeyPath:@"location.lng"] doubleValue];
    
    PFGeoPoint *geo = [PFGeoPoint geoPointWithLatitude:lat longitude:lng];
    [[PFUser currentUser] setObject:geo forKey:@"location"];
    
    // Set location in Parse
    self.userLocation = [PFGeoPoint geoPointWithLatitude:lat longitude:lng];
    [[PFUser currentUser] setObject:self.userLocation forKey:@"location"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Create alert
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Changed"
                                                                           message:@"Your location has been changed."
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            // Create a dismiss action
            UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      // Go back to Settings
                                                                      [self performSegueWithIdentifier:@"toSettings" sender:self];
                                                                  }];
            // Add the cancel action to the alertController
            [alert addAction:dismissAction];
            alert.view.tintColor = [UIColor colorWithRed:134.0/255.0f green:43.0/255.0f blue:142.0/255.0f alpha:1.0f];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self fetchLocationsWithQuery:newText];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchLocationsWithQuery:searchBar.text];
}

- (void)fetchLocationsWithQuery:(NSString *)query {
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/search?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&near=%@,=%@&query=%@", clientID, clientSecret, self.city, self.state, query];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", responseDictionary);
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
