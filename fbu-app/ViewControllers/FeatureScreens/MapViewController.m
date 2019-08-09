//
//  MapViewController.m
//  fbu-app
//
//  Created by lucjia on 8/8/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Parse/Parse.h"

@interface MapViewController () <BulletinViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.center.latitude, self.center.longitude), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:mapRegion animated:false];
    
    self.mapView.delegate = self;
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(self.center.latitude, self.center.longitude);
    point.title = self.venue;
    point.subtitle = [NSString stringWithFormat:@"%@'s Location", self.poster];
    
    [self.mapView addAnnotation:point];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setLocationWithCenter:(nonnull PFGeoPoint *)gp poster:(nonnull NSString *)poster venue:(nonnull NSString *)venue {
    self.center = gp;
    self.poster = poster;
    self.venue = venue;
}

@end
