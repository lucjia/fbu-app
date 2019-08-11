//
//  CreateEventViewController.m
//  fbu-app
//
//  Created by jordan487 on 7/29/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CreateEventViewController.h"
#import "EventLocationViewController.h"
#import "DetailsViewController.h"
#import "CustomDatePicker.h"
#import "Event.h"
#import "CustomColor.h"

@interface CreateEventViewController () <EventLocationViewControllerDelegate>
{
    PFGeoPoint *locationGeoPoint;
}
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UISwitch *allDaySwitch;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;
@property (weak, nonatomic) IBOutlet UITextField *startDateSelectionTextField;
@property (strong, nonatomic) UIDatePicker *startDatePicker;
@property (strong, nonatomic) UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *endDateSelectionTextField;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;


@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[CustomColor darkMainColor:1.0]}];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CustomDatePicker *startDatePicker = [[CustomDatePicker alloc] init];
    self.startDatePicker = [startDatePicker initializeDatePickerWithDatePicker:self.startDatePicker textField:self.startDateSelectionTextField];
    
    CustomDatePicker *endDatePicker = [[CustomDatePicker alloc] init];
    SEL showSelector = @selector(showEndSelectedDate);
    SEL removeSelector = @selector(removeEndDate);
    self.endDatePicker = [endDatePicker initializeDatePickerWithDatePicker:self.endDatePicker textField:self.endDateSelectionTextField selector:showSelector secondSelector:removeSelector];
    
    [self initializeTextView];
}

- (void)didSetLocation:(nonnull NSString *)location geoPoint:(nonnull PFGeoPoint *)geo {
    self.eventLocationLabel.text = [NSString stringWithFormat:@"%@", location];
    locationGeoPoint = geo;
}

- (IBAction)didTapSaveEvent:(id)sender {
    if ([self checkMinimumRequirements]){
        Event *event = [Event createEvent:self.titleTextField.text eventMemo:self.memoTextView.text isAllDay:self.allDaySwitch.isOn eventLocation:locationGeoPoint eventVenue:_eventLocationLabel.text eventStartDate:self.startDatePicker.date eventEndDate:self.endDatePicker.date withCompletion:nil];
        [self.delegate didCreateEvent:event];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)checkMinimumRequirements {
    BOOL canCreateEvent = YES;
    if (![self.titleTextField hasText]){
        [DetailsViewController createAlertController:@"No Title" message:@"Please enter a title" sender:self];
        canCreateEvent = NO;
    }
    if ([self.startDatePicker.date compare:self.endDatePicker.date] == 1 || [self.startDatePicker.date compare:self.endDatePicker.date] == 0) {
        [DetailsViewController createAlertController:@"Invalid Dates" message:@"Please try again" sender:self];
        canCreateEvent = NO;
    }
    
    return canCreateEvent;
}

- (void) showSelectedDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMMM d, yyyy h:mm a"];
    NSString *dueDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.startDatePicker.date]];
    self.startDateSelectionTextField.text = dueDateString;
    [self.startDateSelectionTextField resignFirstResponder];
}

- (void) removeDate {
    [self.startDateSelectionTextField resignFirstResponder];
    [self.startDatePicker setDate:[NSDate date] animated:NO];
    self.startDateSelectionTextField.text = @"";
}

- (void) showEndSelectedDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMMM d, yyyy h:mm a"];
    NSString *dueDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.endDatePicker.date]];
    self.endDateSelectionTextField.text = dueDateString;
    [self.endDateSelectionTextField resignFirstResponder];
}

- (void) removeEndDate {
    [self.endDateSelectionTextField resignFirstResponder];
    [self.endDatePicker setDate:[NSDate date] animated:NO];
    self.endDateSelectionTextField.text = @"";
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) initializeTextView {
    self.memoTextView.layer.borderWidth = 0.5f;
    self.memoTextView.layer.borderColor = [[[UIColor grayColor] colorWithAlphaComponent:0.4] CGColor];
    self.memoTextView.layer.cornerRadius = 5;
    self.memoTextView.delegate = self;
    
    if ([self.memoTextView.text isEqualToString:@""]) {
        self.memoTextView.text = @"Write a memo...";
        self.memoTextView.textColor = [UIColor lightGrayColor];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.memoTextView.text isEqualToString:@"Write a memo..."]) {
        self.memoTextView.text = @"";
        self.memoTextView.textColor = [CustomColor darkMainColor:1.0];
    }
    [self.memoTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.memoTextView.text isEqualToString:@""]) {
        self.memoTextView.text = @"Write a memo...";
        self.memoTextView.textColor = [UIColor lightGrayColor];
    }
    [self.memoTextView resignFirstResponder];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     EventLocationViewController *eventLocationViewController = (EventLocationViewController *)[segue destinationViewController];
     eventLocationViewController.delegate = self;
 }


@end
