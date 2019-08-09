//
//  EventDetailsViewController.m
//  fbu-app
//
//  Created by jordan487 on 8/2/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "CustomColor.h"

static NSDateFormatter *dateFormatter;

@interface EventDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventMemoLabel;

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[CustomColor darkMainColor:1.0]}];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self updateProperties:self.event];
}

- (void)updateProperties:(Event *)event {
    self.eventTitleLabel.text = event.title;
    self.eventTitleLabel.textColor = [CustomColor darkMainColor:1.0];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
    [dateFormatter setDateFormat:@"MMM d, h:mm a"];
    
    NSString *startTime = [dateFormatter stringFromDate:event.eventDate];
    NSString *endTime = [dateFormatter stringFromDate:event.eventEndDate];
    
    self.eventTimeLabel.text = event.isAllDay ? @"All day" : [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    self.eventTimeLabel.textColor = [CustomColor darkMainColor:1.0];
    
    self.eventLocationLabel.text = event.venue;
    self.eventLocationLabel.textColor = [CustomColor darkMainColor:1.0];
    
    self.eventMemoLabel.text = event.memo;
    self.eventMemoLabel.textColor = [CustomColor darkMainColor:1.0];
}

- (IBAction)didTapExit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
