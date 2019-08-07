//
//  LocationViewController.m
//  fbu-app
//
//  Created by lucjia on 7/17/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "LocationViewController.h"
#import "LocationCell.h"
#import "SettingsViewController.h"
#import "Parse/Parse.h"

// Foursquare API
static NSString * const clientID = @"EQAQQVVKNHWZQCKEJA1HUSNOOLCVXZEI3UD5A2XH34VNLPA4";
static NSString * const clientSecret = @"3VJ2WHVGZ4GHBVFBYOXVN2FGNILHHDU4YJBISVQ1X1S0RLYV";

@interface LocationViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    NSString *venue;
}

@property (strong, nonatomic) PFGeoPoint *userLocation;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search for a location...";
    
    if ([[PFUser currentUser][@"persona"] objectForKey:@"venue"] == nil) {
        self.currentLocationLabel.text = @"Choose a location close to where you wish to live!";
    } else {
        self.currentLocationLabel.text = [[PFUser currentUser][@"persona"] objectForKey:@"venue"];
    }
    [self setCity];
}

- (IBAction)didPressSet:(id)sender {
    if (self.userLocation) {
        // Set location in Parse
        [[PFUser currentUser][@"persona"] setObject:self.userLocation forKey:@"geoPoint"];
        [[PFUser currentUser][@"persona"] saveInBackground];
        [self.delegate setLocationLabelWithLocation:venue];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setCity {
    NSString *city = [[PFUser currentUser][@"persona"] objectForKey:@"city"];
    NSString *state = [[PFUser currentUser][@"persona"] objectForKey:@"state"];
    if (![city isEqualToString:@""] && ![state isEqualToString:@""]) {
        self.city = city;
        self.state = state;
    } else {
        self.city = @"San Francisco";
        self.state =@"CA";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is the selected venue
    NSDictionary *venueDetails = self.results[indexPath.row];
    venue = [venueDetails valueForKey:@"name"];
    [[PFUser currentUser][@"persona"] setObject:venue forKey:@"venue"];
    [[PFUser currentUser][@"persona"] saveInBackground];
    
    double lat = [[venueDetails valueForKeyPath:@"location.lat"] doubleValue];
    double lng = [[venueDetails valueForKeyPath:@"location.lng"] doubleValue];
    
    self.userLocation = [PFGeoPoint geoPointWithLatitude:lat longitude:lng];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.searchBar.showsCancelButton = YES;
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self fetchLocationsWithQuery:newText];
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
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
            self.results = [responseDictionary valueForKeyPath:@"response.venues"];
            [self scrollToTopAfterSearch];
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self fetchLocationsWithQuery:searchBar.text];
    [self scrollToTopAfterSearch];
    [self.tableView reloadData];
}

- (void) scrollToTopAfterSearch {
    [self.tableView layoutIfNeeded];
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
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
