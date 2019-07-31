//
//  CreateEventViewController.m
//  fbu-app
//
//  Created by jordan487 on 7/29/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CreateEventViewController.h"
#import "EventLocationViewController.h"
#import "CustomDatePicker.h"
#import "Event.h"

@interface CreateEventViewController () <EventLocationViewControllerDelegate>

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
    
    CustomDatePicker *startDatePicker = [[CustomDatePicker alloc] init];
    self.startDatePicker = [startDatePicker initializeDatePickerWithDatePicker:self.startDatePicker textField:self.startDateSelectionTextField];
    
    CustomDatePicker *endDatePicker = [[CustomDatePicker alloc] init];
    SEL showSelector = @selector(showEndSelectedDate);
    SEL removeSelector = @selector(removeEndDate);
    self.endDatePicker = [endDatePicker initializeDatePickerWithDatePicker:self.endDatePicker textField:self.endDateSelectionTextField selector:showSelector secondSelector:removeSelector];
}

- (IBAction)didTapAddLocation:(id)sender {
    
}

- (IBAction)didTapSaveEvent:(id)sender {
    Event *event = [Event createEvent:self.titleTextField.text eventMemo:self.memoTextView.text isAllDay:self.allDaySwitch.isOn eventStartDate:self.startDatePicker.date eventEndDate:self.endDatePicker.date withCompletion:nil];
    [self.delegate didCreateEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
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


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     EventLocationViewController *eventLocationViewController = (EventLocationViewController *)[segue destinationViewController];
     eventLocationViewController.delegate = self;
 }
 

- (void)didSetLocation:(nonnull NSString *)location {
    self. eventLocationLabel.text = [NSString stringWithFormat:@"%@", location];
}

@end
