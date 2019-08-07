//
//  EventLocationViewController.m
//  fbu-app
//
//  Created by jordan487 on 7/31/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "EventLocationViewController.h"
#import <Parse/Parse.h>
#import "LocationCell.h"
#import "Persona.h"
#import "DetailsViewController.h"
#import "CustomColor.h"

// Foursquare API
static NSString * const clientID = @"EQAQQVVKNHWZQCKEJA1HUSNOOLCVXZEI3UD5A2XH34VNLPA4";
static NSString * const clientSecret = @"3VJ2WHVGZ4GHBVFBYOXVN2FGNILHHDU4YJBISVQ1X1S0RLYV";

@interface EventLocationViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    NSArray *results;
    NSString *city;
    NSString *state;
    PFGeoPoint *eventLocation;
    NSString *eventLocationString;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation EventLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[CustomColor darkMainColor:1.0]];
    [self.tableView setBackgroundColor:[CustomColor darkMainColor:1.0]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search for a location...";
    
    [self setCity];
}

- (IBAction)didTapSetLocation:(id)sender {
    if (eventLocation) {
        [self.delegate didSetLocation:eventLocationString geoPoint:eventLocation];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [DetailsViewController createAlertController:@"No location set" message:@"Please set a location." sender:self];
    }
}

- (void) setCity {
    NSString *currentCity = [[PFUser currentUser][@"persona"] objectForKey:@"city"];
    NSString *currentState = [[PFUser currentUser][@"persona"] objectForKey:@"state"];
    if (![city isEqualToString:@""] && ![state isEqualToString:@""]) {
        city = currentCity;
        state = currentState;
    } else {
        city = @"San Francisco";
        state =@"CA";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is the selected venue
    NSDictionary *venue = results[indexPath.row];
    
    double lat = [[venue valueForKeyPath:@"location.lat"] doubleValue];
    double lng = [[venue valueForKeyPath:@"location.lng"] doubleValue];
    
    NSDictionary *locationDictionary = results[indexPath.row];
    
    // Set location in Parse
    eventLocation = [PFGeoPoint geoPointWithLatitude:lat longitude:lng];
    eventLocationString = locationDictionary[@"name"];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self fetchLocationsWithQuery:newText];
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchLocationsWithQuery:searchBar.text];
}

- (void)fetchLocationsWithQuery:(NSString *)query {
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/search?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&near=%@,=%@&query=%@", clientID, clientSecret, city, state, query];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self->results = [responseDictionary valueForKeyPath:@"response.venues"];
            [self.tableView reloadData];
        }
    }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return results.count;
}

// Determines which cell is at each row (returns an instance of the custom cell
// with reuse identifier with the data that the index asked for
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventLocationCell" forIndexPath:indexPath];
    
    [cell updateWithLocation:results[indexPath.row]];
    return cell;
    
}

@end
