//
//  CreateEventViewController.m
//  fbu-app
//
//  Created by jordan487 on 7/29/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CreateEventViewController.h"
#import "CustomDatePicker.h"
#import "Event.h"

@interface CreateEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UISwitch *allDaySwitch;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;
@property (weak, nonatomic) IBOutlet UITextField *dateSelectionTextField;
@property (strong, nonatomic) UIDatePicker *datePicker;


@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CustomDatePicker *dp = [[CustomDatePicker alloc] init];
    self.datePicker = [dp initializeDatePickerWithDatePicker:self.datePicker textField:self.dateSelectionTextField];
}

- (IBAction)didTapAddLocation:(id)sender {
    
}

- (IBAction)didTapSaveEvent:(id)sender {
    [Event createEvent:self.titleTextField.text eventMemo:self.memoTextView.text isAllDay:self.allDaySwitch.isOn eventDate:self.datePicker.date withCompletion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) showSelectedDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMMM d, yyyy h:mm a"];
    NSString *dueDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
    self.dateSelectionTextField.text = dueDateString;
    [self.dateSelectionTextField resignFirstResponder];
}

- (void) removeDate {
    [self.dateSelectionTextField resignFirstResponder];
    [self.datePicker setDate:[NSDate date] animated:NO];
    self.dateSelectionTextField.text = @"";
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
